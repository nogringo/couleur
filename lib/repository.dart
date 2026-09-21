import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:ndk/ndk.dart';
import 'package:ndk_flutter/ndk_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:couleur/config.dart';
import 'package:couleur/controllers/auth_controller.dart';
import 'package:couleur/models/mute_list.dart';

class Repository extends GetxController {
  static Repository get to => Get.find();
  static Ndk get ndk => Get.find();
  static NdkFlutter get ndkFlutter => Get.find();

  final SharedPreferences box = Get.find();

  final RxMap<String, String> names = <String, String>{}.obs;
  final Map<String, Future<Metadata?>> _metadataRequests = {};
  final Set<String> _displayedEventIds = {};
  Map<String, RxList<Nip01Event>> rooms = {globalRoom: <Nip01Event>[].obs};
  RxList<String> starredRooms = <String>[].obs;
  MuteList? muteList;
  RxString selectedRoom = globalRoom.obs;
  final sendFieldController = TextEditingController();
  final sendFieldFocusNode = FocusNode();
  NdkResponse? roomsSubscription;
  RxInt minimumPowDifficulty = defaultMinimumPowDifficulty.obs;
  RxBool includeClientTag = true.obs;

  @override
  void onInit() {
    super.onInit();
    loadStarredRooms();
    loadPowSettings();
    loadClientTagSettings();
    fetchMuteList();
  }

  void loadStarredRooms() {
    final stored = box.getStringList('starredRooms');
    if (stored == null) return;
    starredRooms.value = stored;

    for (String starredRoom in starredRooms) {
      if (rooms.containsKey(starredRoom)) continue;
      rooms[starredRoom] = <Nip01Event>[].obs;
    }
  }

  void saveStarredRooms() {
    box.setStringList('starredRooms', starredRooms.toList());
  }

  void loadPowSettings() {
    final stored = box.getInt('minimumPowDifficulty');
    if (stored != null) {
      minimumPowDifficulty.value = stored;
    }
  }

  void savePowSettings() {
    box.setInt('minimumPowDifficulty', minimumPowDifficulty.value);
  }

  void setMinimumPowDifficulty(int difficulty) {
    minimumPowDifficulty.value = difficulty;
    savePowSettings();
  }

  void loadClientTagSettings() {
    final stored = box.getBool('includeClientTag');
    if (stored != null) {
      includeClientTag.value = stored;
    }
  }

  void saveClientTagSettings() {
    box.setBool('includeClientTag', includeClientTag.value);
  }

  void setIncludeClientTag(bool value) {
    includeClientTag.value = value;
    saveClientTagSettings();
  }

  void toggleStarRoom(String roomId) {
    if (starredRooms.contains(roomId)) {
      starredRooms.remove(roomId);
    } else {
      starredRooms.add(roomId);
    }
    saveStarredRooms();
  }

  bool isRoomStarred(String roomId) {
    return starredRooms.contains(roomId);
  }

  List<String> getPopularRooms() {
    final timeWindowAgo = DateTime.now().subtract(
      Duration(minutes: popularRoomTimeWindowMinutes),
    );

    final popularRooms =
        rooms.entries
            .map((entry) {
              // Get messages from time window
              final recentMessages = entry.value.where((event) {
                final eventTime = DateTime.fromMillisecondsSinceEpoch(
                  event.createdAt * 1000,
                );
                return eventTime.isAfter(timeWindowAgo);
              }).toList();

              // Count unique users
              final uniqueUsers = recentMessages
                  .map((event) => event.pubKey)
                  .toSet()
                  .length;

              // Room is popular if it meets the configured criteria
              final isPopular =
                  recentMessages.length >= popularRoomMinMessages &&
                  uniqueUsers >= popularRoomMinUniqueUsers;

              return MapEntry(entry.key, isPopular ? recentMessages.length : 0);
            })
            .where(
              (entry) => entry.value > 0,
            ) // Only rooms meeting the criteria
            .toList()
          ..sort((a, b) => b.value.compareTo(a.value));

    return popularRooms
        .take(popularRoomMaxDisplay)
        .map((entry) => entry.key)
        .toList();
  }

  void listenRooms() {
    if (roomsSubscription != null) return;

    roomsSubscription = ndk.requests.subscription(
      filter: Filter(
        kinds: [20000, 23333],
        since: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      ),
    );

    roomsSubscription!.stream.listen(onEvent);
  }

  Future<void> onEvent(Nip01Event event) async {
    // Check if the user is muted
    if (muteList != null && muteList!.isMuted(event.pubKey)) {
      return; // Skip events from muted users
    }

    // Check for proof of work
    if (!_hasValidProofOfWork(event)) {
      return; // Skip events without valid POW
    }

    String? gTag = event.getFirstTag("g");
    if (gTag != null) gTag = "bc_$gTag";

    final dTag = event.getFirstTag("d");

    final roomName = gTag ?? dTag;
    if (roomName == null) return;

    addMessage(roomName, event);
  }

  void addMessage(String roomName, Nip01Event event) {
    if (!_displayedEventIds.add(event.id)) return;

    names[event.pubKey] ??= _tagName(event);

    if (!rooms.containsKey(roomName)) {
      rooms[roomName] = <Nip01Event>[].obs;
    }
    rooms[roomName]!.add(event);
    update();

    _refineName(event.pubKey);
  }

  String displayName(Nip01Event event) {
    return names[event.pubKey] ?? _tagName(event);
  }

  String _tagName(Nip01Event event) {
    final uid = event.pubKey.substring(event.pubKey.length - 4);
    final nTag = event.getFirstTag("n");
    return nTag != null ? "$nTag#$uid" : "Anon#$uid";
  }

  Future<void> _refineName(String pubKey) async {
    final metadata = await loadMetadata(pubKey);
    final name = metadata?.displayName ?? metadata?.name;
    if (name == null || names[pubKey] == name) return;

    names[pubKey] = name;
    update();
  }

  /// ndk never caches a missing profile, so each lookup of a profileless pubkey
  /// costs a 5s timeout: keep one future per pubkey instead of re-querying.
  Future<Metadata?> loadMetadata(String pubKey) {
    return _metadataRequests.putIfAbsent(
      pubKey,
      () => ndk.metadata.loadMetadata(pubKey).onError((_, _) => null),
    );
  }

  Future<void> sendMessage() async {
    final content = sendFieldController.text;
    if (content.isEmpty) return;

    await AuthController.to.ensureAccount();

    final pubkey = ndk.accounts.getPublicKey();
    if (pubkey == null) return;

    sendFieldController.clear();
    sendFieldFocusNode.requestFocus();

    final metadata = await loadMetadata(
      pubkey,
    ).timeout(nTagLookupTimeout, onTimeout: () => null);
    final nTag = metadata?.displayName ?? metadata?.name;

    final roomKey = selectedRoom.value;
    final isGeoHash = roomKey.startsWith("bc_");
    final kind = isGeoHash ? 20000 : 23333;
    final tag = isGeoHash ? "g" : "d";
    final room = isGeoHash ? roomKey.substring(3) : roomKey;

    // Check if POW is required
    if (minimumPowDifficulty.value == 0) {
      // No POW required, send message directly
      final nostrEvent = Nip01Event(
        pubKey: pubkey,
        kind: kind,
        tags: [
          [tag, room],
          if (nTag != null) ["n", nTag],
          if (includeClientTag.value) ["client", appTitle],
        ],
        content: content,
        // ndk hashes its own now() when createdAt is left out, so the id can
        // end up signed over a different second than the event carries
        createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      );
      ndk.broadcast.broadcast(nostrEvent: nostrEvent);
      addMessage(roomKey, nostrEvent);
      return;
    }

    // Mine for proof of work
    final targetDifficulty = minimumPowDifficulty.value;
    Nip01Event? minedEvent;
    int nonce = 0;

    while (minedEvent == null) {
      final nostrEvent = Nip01Event(
        pubKey: pubkey,
        kind: kind,
        tags: [
          [tag, room],
          if (nTag != null) ["n", nTag],
          if (includeClientTag.value) ["client", appTitle],
          ["nonce", nonce.toString(), targetDifficulty.toString()],
        ],
        content: content,
        createdAt: DateTime.now().millisecondsSinceEpoch ~/ 1000,
      );

      // Check if this event meets the difficulty requirement
      if (_countLeadingZeroBits(nostrEvent.id) >= targetDifficulty) {
        minedEvent = nostrEvent;
        break;
      }

      nonce++;

      // Allow UI to remain responsive
      if (nonce % 1000 == 0) {
        await Future.delayed(Duration.zero);
      }
    }

    ndk.broadcast.broadcast(nostrEvent: minedEvent);
    addMessage(roomKey, minedEvent);
  }

  Future<void> fetchMuteList() async {
    final pubkey = ndk.accounts.getPublicKey();
    if (pubkey == null) return;

    final res = ndk.requests.query(
      filter: Filter(kinds: [10000], authors: [pubkey], limit: 1),
    );

    final muteEvents = await res.future;
    if (muteEvents.isEmpty) {
      muteList = MuteList(
        publicMutedPubkeys: [],
        publicMutedWords: [],
        publicMutedHashtags: [],
        publicMutedThreads: [],
        privateMutedPubkeys: [],
        privateMutedWords: [],
        privateMutedHashtags: [],
        privateMutedThreads: [],
      );
      return;
    }

    final muteEvent = muteEvents.first;

    // Decrypt private content if exists
    String? decryptedContent;
    if (muteEvent.content.isNotEmpty) {
      final signer = ndk.accounts.getLoggedAccount()!.signer;

      try {
        decryptedContent = await signer.decryptNip44(
          ciphertext: muteEvent.content,
          senderPubKey: muteEvent.pubKey,
        );
      } catch (e) {
        //
      }

      if (decryptedContent == null) {
        try {
          // lists written before NIP-51 moved to nip44
          // ignore: deprecated_member_use
          decryptedContent = await signer.decrypt(
            muteEvent.content,
            muteEvent.pubKey,
          );
        } catch (e) {
          //
        }
      }
    }

    // Parse mute list from event
    muteList = MuteList.fromEventData(
      tags: muteEvent.tags,
      decryptedContent: decryptedContent,
    );

    update(); // Notify UI of changes
  }

  bool _hasValidProofOfWork(Nip01Event event) {
    // NIP-13: Proof of Work
    // Look for nonce tag format: ["nonce", "<nonce>", "<target_difficulty>"]
    final nonceTag = event.tags.firstWhere(
      (tag) => tag.length >= 3 && tag[0] == 'nonce',
      orElse: () => [],
    );

    if (nonceTag.isEmpty || nonceTag.length < 3) {
      // If no POW tag and minimum difficulty > 0, reject the event
      return minimumPowDifficulty.value == 0;
    }

    // Extract target difficulty from the nonce tag
    final targetDifficulty = int.tryParse(nonceTag[2]) ?? 0;

    // NIP-13: Count leading zero bits in the event ID (SHA-256 hash)
    final eventIdBits = _countLeadingZeroBits(event.id);

    // Event must meet both the tag difficulty and our minimum difficulty
    final requiredDifficulty = targetDifficulty > minimumPowDifficulty.value
        ? targetDifficulty
        : minimumPowDifficulty.value;

    return eventIdBits >= requiredDifficulty;
  }

  int _countLeadingZeroBits(String hexString) {
    int bits = 0;
    for (int i = 0; i < hexString.length; i++) {
      final char = hexString[i];
      final value = int.parse(char, radix: 16);

      // According to NIP-13: Count leading zero bits
      // Each hex character represents 4 bits
      if (value == 0) {
        bits += 4;
      } else {
        // For non-zero values, count the leading zeros in the 4-bit representation
        if (value <= 0x7) {
          // 0x1-0x7 have at least 1 leading zero bit (0001 to 0111)
          if (value <= 0x3) {
            // 0x1-0x3 have at least 2 leading zero bits (0001 to 0011)
            if (value == 0x1) {
              // 0x1 has 3 leading zero bits (0001)
              bits += 3;
            } else {
              // 0x2-0x3 have 2 leading zero bits (0010, 0011)
              bits += 2;
            }
          } else {
            // 0x4-0x7 have 1 leading zero bit (0100 to 0111)
            bits += 1;
          }
        }
        // 0x8-0xF have no leading zero bits (1000 to 1111)
        break;
      }
    }
    return bits;
  }

  Future<void> muteUser(String pubKey, {bool private = false}) async {
    // Fetch latest mute list if not loaded
    if (muteList == null) {
      await fetchMuteList();
    }

    // Create or update mute list
    muteList ??= MuteList(
      publicMutedPubkeys: [],
      publicMutedWords: [],
      publicMutedHashtags: [],
      publicMutedThreads: [],
      privateMutedPubkeys: [],
      privateMutedWords: [],
      privateMutedHashtags: [],
      privateMutedThreads: [],
    );

    // Add pubkey to mute list
    muteList = muteList!.addPubkey(pubKey, private: private);

    // Create encrypted content for private mutes
    String content = '';
    if (muteList!.privateMutedPubkeys.isNotEmpty ||
        muteList!.privateMutedWords.isNotEmpty ||
        muteList!.privateMutedHashtags.isNotEmpty ||
        muteList!.privateMutedThreads.isNotEmpty) {
      try {
        final privateContent = muteList!.toPrivateContent();
        final encrypted = await ndk.accounts
            .getLoggedAccount()!
            .signer
            .encryptNip44(
              plaintext: privateContent,
              recipientPubKey: ndk.accounts.getPublicKey()!,
            );
        content = encrypted ?? '';
      } catch (e) {
        //
      }
    }

    // Create mute list event
    final muteEvent = Nip01Event(
      pubKey: ndk.accounts.getPublicKey()!,
      kind: 10000,
      tags: muteList!.toPublicTags(),
      content: content,
    );

    // Publish the mute list
    ndk.broadcast.broadcast(nostrEvent: muteEvent);

    update(); // Notify UI
  }
}

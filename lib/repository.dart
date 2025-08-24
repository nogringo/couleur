import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ndk/ndk.dart';
import 'package:couleur/config.dart';
import 'package:couleur/models/mute_list.dart';

class Repository extends GetxController {
  static Repository get to => Get.find();
  static Ndk get ndk => Get.find();

  final box = GetStorage();

  Map<String, String> names = {};
  Map<String, RxList<Nip01Event>> rooms = {globalRoom: <Nip01Event>[].obs};
  RxList<String> starredRooms = <String>[].obs;
  MuteList? muteList;
  RxString selectedRoom = globalRoom.obs;
  final sendFieldController = TextEditingController();
  final sendFieldFocusNode = FocusNode();
  NdkResponse? roomsSubscription;

  @override
  void onInit() {
    super.onInit();
    loadStarredRooms();
    fetchMuteList();
  }

  void loadStarredRooms() {
    final stored = box.read<List>('starredRooms');
    if (stored == null) return;
    starredRooms.value = List<String>.from(stored);

    for (String starredRoom in starredRooms) {
      if (rooms.containsKey(starredRoom)) continue;
      rooms[starredRoom] = <Nip01Event>[].obs;
    }
  }

  void saveStarredRooms() {
    box.write('starredRooms', starredRooms.toList());
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

  listenRooms() {
    if (roomsSubscription != null) return;

    roomsSubscription = ndk.requests.subscription(
      filters: [
        Filter(
          kinds: [20000, 23333],
          since: DateTime.now().millisecondsSinceEpoch ~/ 1000,
        ),
      ],
    );

    roomsSubscription!.stream.listen(onEvent);
  }

  onEvent(Nip01Event event) async {
    // Check if the user is muted
    if (muteList != null && muteList!.isMuted(event.pubKey)) {
      return; // Skip events from muted users
    }

    final uid = event.pubKey.substring(event.pubKey.length - 4);
    final nTag = event.getFirstTag("n");
    if (nTag == null) {
      final metadata = await ndk.metadata.loadMetadata(event.pubKey);
      final anonName = "Anon#$uid";
      if (metadata != null) {
        names[event.pubKey] = metadata.displayName ?? metadata.name ?? anonName;
      } else {
        names[event.pubKey] = anonName;
      }
    } else {
      names[event.pubKey] = "$nTag#$uid";
    }

    String? gTag = event.getFirstTag("g");
    if (gTag != null) gTag = "bc_$gTag";

    final dTag = event.getFirstTag("d");

    final roomName = gTag ?? dTag;
    if (roomName == null) return;

    if (!rooms.containsKey(roomName)) {
      rooms[roomName] = <Nip01Event>[].obs;
    }
    rooms[roomName]!.add(event);
    update();
  }

  sendMessage() {
    if (sendFieldController.text.isEmpty) return;

    final isGeoHash = selectedRoom.startsWith("bc_");
    final kind = isGeoHash ? 20000 : 23333;
    final tag = isGeoHash ? "g" : "d";
    final room = isGeoHash ? selectedRoom.substring(3) : selectedRoom.value;
    final nostrEvent = Nip01Event(
      pubKey: ndk.accounts.getPublicKey()!,
      kind: kind,
      tags: [
        [tag, room],
      ],
      content: sendFieldController.text,
    );
    ndk.broadcast.broadcast(nostrEvent: nostrEvent);

    sendFieldController.clear();
    sendFieldFocusNode.requestFocus();
  }

  Future<void> fetchMuteList() async {
    final pubkey = ndk.accounts.getPublicKey();
    if (pubkey == null) return;

    final res = ndk.requests.query(
      filters: [
        Filter(kinds: [10000], authors: [pubkey], limit: 1),
      ],
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
      try {
        decryptedContent = await ndk.accounts
            .getLoggedAccount()!
            .signer
            .decrypt(muteEvent.content, muteEvent.pubKey);
      } catch (e) {
        print('Error decrypting mute list: $e');
      }
    }

    // Parse mute list from event
    muteList = MuteList.fromEventData(
      tags: muteEvent.tags,
      decryptedContent: decryptedContent,
    );

    update(); // Notify UI of changes
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
        final encrypted = await ndk.accounts.getLoggedAccount()!.signer.encrypt(
          privateContent,
          ndk.accounts.getPublicKey()!,
        );
        content = encrypted ?? '';
      } catch (e) {
        print('Error encrypting private mute list: $e');
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

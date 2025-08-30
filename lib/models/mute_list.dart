import 'dart:convert';

class MuteList {
  // Public mutes (visible in tags)
  final List<String> publicMutedPubkeys;
  final List<String> publicMutedWords;
  final List<String> publicMutedHashtags;
  final List<String> publicMutedThreads;

  // Private mutes (encrypted in content)
  final List<String> privateMutedPubkeys;
  final List<String> privateMutedWords;
  final List<String> privateMutedHashtags;
  final List<String> privateMutedThreads;

  MuteList({
    required this.publicMutedPubkeys,
    required this.publicMutedWords,
    required this.publicMutedHashtags,
    required this.publicMutedThreads,
    required this.privateMutedPubkeys,
    required this.privateMutedWords,
    required this.privateMutedHashtags,
    required this.privateMutedThreads,
  });

  // Get all muted items (both public and private)
  List<String> get allMutedPubkeys => [
    ...publicMutedPubkeys,
    ...privateMutedPubkeys,
  ];

  List<String> get allMutedWords => [...publicMutedWords, ...privateMutedWords];

  List<String> get allMutedHashtags => [
    ...publicMutedHashtags,
    ...privateMutedHashtags,
  ];

  List<String> get allMutedThreads => [
    ...publicMutedThreads,
    ...privateMutedThreads,
  ];

  // Check if a pubkey is muted
  bool isMuted(String pubkey) => allMutedPubkeys.contains(pubkey);

  // Check if a word is muted
  bool isWordMuted(String word) => allMutedWords.contains(word);

  // Check if a hashtag is muted
  bool isHashtagMuted(String hashtag) => allMutedHashtags.contains(hashtag);

  // Check if a thread is muted
  bool isThreadMuted(String eventId) => allMutedThreads.contains(eventId);

  // Create public tags for the event
  List<List<String>> toPublicTags() {
    return [
      ...publicMutedPubkeys.map((p) => ['p', p]),
      ...publicMutedHashtags.map((t) => ['t', t]),
      ...publicMutedWords.map((w) => ['word', w]),
      ...publicMutedThreads.map((e) => ['e', e]),
    ];
  }

  // Create private content for encryption
  String toPrivateContent() {
    final privateTags = [
      ...privateMutedPubkeys.map((p) => ['p', p]),
      ...privateMutedHashtags.map((t) => ['t', t]),
      ...privateMutedWords.map((w) => ['word', w]),
      ...privateMutedThreads.map((e) => ['e', e]),
    ];
    return jsonEncode(privateTags);
  }

  // Parse from event tags and encrypted content
  static MuteList fromEventData({
    required List<List<String>> tags,
    String? decryptedContent,
  }) {
    final publicMutedPubkeys = <String>[];
    final publicMutedHashtags = <String>[];
    final publicMutedWords = <String>[];
    final publicMutedThreads = <String>[];

    // Parse public tags
    for (final tag in tags) {
      if (tag.length < 2) continue;

      switch (tag[0]) {
        case 'p':
          publicMutedPubkeys.add(tag[1]);
          break;
        case 't':
          publicMutedHashtags.add(tag[1]);
          break;
        case 'word':
          publicMutedWords.add(tag[1]);
          break;
        case 'e':
          publicMutedThreads.add(tag[1]);
          break;
      }
    }

    // Parse private encrypted content
    final privateMutedPubkeys = <String>[];
    final privateMutedHashtags = <String>[];
    final privateMutedWords = <String>[];
    final privateMutedThreads = <String>[];

    if (decryptedContent != null && decryptedContent.isNotEmpty) {
      try {
        final privateList = jsonDecode(decryptedContent) as List;
        for (final item in privateList) {
          if (item is List && item.length >= 2) {
            switch (item[0]) {
              case 'p':
                privateMutedPubkeys.add(item[1] as String);
                break;
              case 't':
                privateMutedHashtags.add(item[1] as String);
                break;
              case 'word':
                privateMutedWords.add(item[1] as String);
                break;
              case 'e':
                privateMutedThreads.add(item[1] as String);
                break;
            }
          }
        }
      } catch (e) {
        // 
      }
    }

    return MuteList(
      publicMutedPubkeys: publicMutedPubkeys,
      publicMutedWords: publicMutedWords,
      publicMutedHashtags: publicMutedHashtags,
      publicMutedThreads: publicMutedThreads,
      privateMutedPubkeys: privateMutedPubkeys,
      privateMutedWords: privateMutedWords,
      privateMutedHashtags: privateMutedHashtags,
      privateMutedThreads: privateMutedThreads,
    );
  }

  // Add a pubkey to the mute list
  MuteList addPubkey(String pubkey, {bool private = false}) {
    if (private) {
      if (privateMutedPubkeys.contains(pubkey)) return this;
      return MuteList(
        publicMutedPubkeys: publicMutedPubkeys,
        publicMutedWords: publicMutedWords,
        publicMutedHashtags: publicMutedHashtags,
        publicMutedThreads: publicMutedThreads,
        privateMutedPubkeys: [...privateMutedPubkeys, pubkey],
        privateMutedWords: privateMutedWords,
        privateMutedHashtags: privateMutedHashtags,
        privateMutedThreads: privateMutedThreads,
      );
    } else {
      if (publicMutedPubkeys.contains(pubkey)) return this;
      return MuteList(
        publicMutedPubkeys: [...publicMutedPubkeys, pubkey],
        publicMutedWords: publicMutedWords,
        publicMutedHashtags: publicMutedHashtags,
        publicMutedThreads: publicMutedThreads,
        privateMutedPubkeys: privateMutedPubkeys,
        privateMutedWords: privateMutedWords,
        privateMutedHashtags: privateMutedHashtags,
        privateMutedThreads: privateMutedThreads,
      );
    }
  }

  // Remove a pubkey from the mute list
  MuteList removePubkey(String pubkey) {
    return MuteList(
      publicMutedPubkeys: publicMutedPubkeys.where((p) => p != pubkey).toList(),
      publicMutedWords: publicMutedWords,
      publicMutedHashtags: publicMutedHashtags,
      publicMutedThreads: publicMutedThreads,
      privateMutedPubkeys: privateMutedPubkeys
          .where((p) => p != pubkey)
          .toList(),
      privateMutedWords: privateMutedWords,
      privateMutedHashtags: privateMutedHashtags,
      privateMutedThreads: privateMutedThreads,
    );
  }
}

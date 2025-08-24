import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ndk/ndk.dart';
import 'package:couleur/repository.dart';
import 'package:couleur/screens/chat/chat_screen.dart';
import 'package:nostr_widgets/l10n/app_localizations.dart' as nostr_widgets;
import 'package:nostr_widgets/nostr_widgets.dart';

class NoEventVerifier extends EventVerifier {
  @override
  Future<bool> verify(Nip01Event event) async {
    return true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await GetStorage.init();

  final ndk = Ndk(
    NdkConfig(
      eventVerifier: NoEventVerifier(),
      cache: MemCacheManager(),
      bootstrapRelays: [
        "wss://relay.primal.net",
        "wss://relay.damus.io",
        "wss://nos.lol",
        "wss://relay.snort.social",
      ],
    ),
  );
  Get.put(ndk);

  await nRestoreAccounts(ndk);

  Get.put(Repository());

  Repository.to.listenRooms();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      title: "Nostr chat",
      localizationsDelegates: [nostr_widgets.AppLocalizations.delegate],
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.light,
        ),
        useMaterial3: true,
      ),
      darkTheme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: Colors.teal,
          brightness: Brightness.dark,
        ),
        useMaterial3: true,
      ),
      home: ChatScreen(),
    );
  }
}

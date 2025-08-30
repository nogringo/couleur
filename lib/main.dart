import 'package:couleur/config.dart';
import 'package:couleur/controllers/auth_controller.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';
import 'package:ndk/ndk.dart';
import 'package:couleur/repository.dart';
import 'package:couleur/controllers/theme_controller.dart';
import 'package:couleur/screens/chat/chat_screen.dart';
import 'package:nostr_widgets/l10n/app_localizations.dart' as nostr_widgets;
import 'package:nostr_widgets/l10n/app_localizations.dart';
import 'package:nostr_widgets/nostr_widgets.dart';
import 'package:window_manager/window_manager.dart';
import 'package:system_theme/system_theme.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

class NoEventVerifier extends EventVerifier {
  @override
  Future<bool> verify(Nip01Event event) async {
    return true;
  }
}

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  if (!kIsWeb && GetPlatform.isDesktop) {
    await windowManager.ensureInitialized();
    await windowManager.setTitleBarStyle(TitleBarStyle.hidden);
  }

  await SystemTheme.accentColor.load();

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
        "wss://nostr21.com",
        "wss://offchain.pub",
      ],
    ),
  );
  Get.put(ndk);

  await nRestoreAccounts(ndk);

  Get.put(AuthController());
  Get.put(Repository());
  Get.put(ThemeController());

  Repository.to.listenRooms();

  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return SystemThemeBuilder(
      builder: (context, accent) {
        final supportAccentColor = defaultTargetPlatform.supportsAccentColor;
        Color accentColor = supportAccentColor ? accent.accent : Colors.teal;
        if (kIsWeb) accentColor = Colors.teal;

        ThemeData getTheme([Brightness? brightness]) {
          brightness = brightness ?? Brightness.light;

          final colorScheme = ColorScheme.fromSeed(
            seedColor: accentColor,
            brightness: brightness,
          );

          return ThemeData(
            colorScheme: colorScheme,
            brightness: brightness,
            useMaterial3: true,
          );
        }

        final app = Obx(
          () => GetMaterialApp(
            debugShowCheckedModeBanner: false,
            title: appTitle,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
              GlobalCupertinoLocalizations.delegate,
              nostr_widgets.AppLocalizations.delegate,
            ],
            supportedLocales: AppLocalizations.supportedLocales,
            theme: getTheme(),
            darkTheme: getTheme(Brightness.dark),
            themeMode: ThemeController.to.themeMode,
            home: ChatScreen(),
          ),
        );

        if (!kIsWeb && GetPlatform.isDesktop) {
          return Directionality(
            textDirection: TextDirection.ltr,
            child: DragToResizeArea(child: app),
          );
        }

        return app;
      },
    );
  }
}

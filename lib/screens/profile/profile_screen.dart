import 'package:couleur/config.dart';
import 'package:couleur/l10n/app_localizations.dart';
import 'package:couleur/repository.dart';
import 'package:couleur/widgets/github_icon_painter.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'widgets/pow_filter_tile.dart';
import 'widgets/profile_header.dart';
import 'widgets/settings_group.dart';
import 'widgets/settings_link_tile.dart';
import 'widgets/settings_section_header.dart';
import 'widgets/settings_switch_tile.dart';
import 'widgets/theme_mode_tile.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final pubkey = Repository.ndk.accounts.getPublicKey();

    return Scaffold(
      appBar: AppBar(),
      body: SafeArea(
        top: false,
        child: SingleChildScrollView(
          child: Align(
            alignment: Alignment.topCenter,
            child: ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 500),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  if (pubkey != null)
                    Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16),
                      child: ProfileHeader(pubkey: pubkey),
                    ),
                  SettingsSectionHeader(title: l10n?.themeMode ?? 'Theme Mode'),
                  SettingsGroup(
                    rows: [
                      for (final mode in ThemeMode.values)
                        (index, count) => ThemeModeTile(
                          mode: mode,
                          index: index,
                          count: count,
                        ),
                    ],
                  ),
                  SettingsSectionHeader(title: l10n?.privacy ?? 'Privacy'),
                  SettingsGroup(
                    rows: [
                      (index, count) =>
                          PowFilterTile(index: index, count: count),
                      (index, count) => Obx(
                        () => SettingsSwitchTile(
                          icon: Icons.tag,
                          title:
                              l10n?.letOthersKnow(appTitle) ??
                              'Let others know I use $appTitle',
                          value: Repository.to.includeClientTag.value,
                          onChanged: Repository.to.setIncludeClientTag,
                          index: index,
                          count: count,
                        ),
                      ),
                    ],
                  ),
                  SettingsSectionHeader(title: l10n?.about ?? 'About'),
                  SettingsGroup(
                    rows: [
                      (index, count) => SettingsLinkTile(
                        leading: CustomPaint(
                          size: const Size(24, 24),
                          painter: GitHubIconPainter(
                            color: Theme.of(context).colorScheme.onSurface,
                          ),
                        ),
                        title: l10n?.sourceCode ?? 'Source Code',
                        subtitle: l10n?.viewOnGitHub ?? 'View on GitHub',
                        url: 'https://github.com/nogringo/couleur',
                        index: index,
                        count: count,
                      ),
                      (index, count) => SettingsLinkTile(
                        leading: const Icon(Icons.favorite),
                        title: l10n?.supportAndContact ?? 'Support & Contact',
                        subtitle:
                            l10n?.donateOrGetInTouch ??
                            'Donate or get in touch via Nostr',
                        url:
                            'https://nosta.me/b22b06b051fd5232966a9344a634d956c3dc33a7f5ecdcad9ed11ddc4120a7f2',
                        index: index,
                        count: count,
                      ),
                    ],
                  ),
                  const SizedBox(height: 32),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

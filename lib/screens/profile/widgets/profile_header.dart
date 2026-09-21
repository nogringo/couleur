import 'package:couleur/controllers/auth_controller.dart';
import 'package:couleur/repository.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:ndk_flutter/ndk_flutter.dart';

/// Banner and avatar from ndk_flutter, with the name resolved the way a message
/// author is, so a profileless account reads as its `Anon#uid` handle instead of
/// an npub.
class ProfileHeader extends StatelessWidget {
  const ProfileHeader({super.key, required this.pubkey});

  final String pubkey;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        NUserProfile(
          ndkFlutter: Repository.ndkFlutter,
          showName: false,
          showNip05: false,
          showLogoutButton: !AuthController.to.isAnonymous,
          onLogout: () async {
            await AuthController.to.ensureAccount();
            Get.back();
            AuthController.to.update();
          },
        ),
        const SizedBox(height: 16),
        Obx(() {
          final nip05 = Repository.to.nip05s[pubkey];
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Flexible(
                    child: Text(
                      Repository.to.displayNameOf(pubkey),
                      style: theme.textTheme.displaySmall,
                    ),
                  ),
                  if (nip05 != null)
                    Padding(
                      padding: const EdgeInsets.only(left: 8),
                      child: Icon(
                        Icons.verified,
                        color: theme.colorScheme.primary,
                      ),
                    ),
                ],
              ),
              if (nip05 != null)
                Text(nip05, style: TextStyle(color: theme.disabledColor)),
            ],
          );
        }),
      ],
    );
  }
}

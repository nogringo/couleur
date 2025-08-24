import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:couleur/repository.dart';
import 'package:couleur/screens/profile/profile_screen.dart';
import 'package:nostr_widgets/nostr_widgets.dart';

class ProfilePictureButtonView extends StatelessWidget {
  const ProfilePictureButtonView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.to(() => ProfileScreen());
      },
      child: NPicture(ndk: Repository.ndk),
    );
  }
}

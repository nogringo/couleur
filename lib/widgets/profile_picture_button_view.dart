import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:couleur/repository.dart';
import 'package:couleur/routes.dart';
import 'package:ndk_flutter/ndk_flutter.dart';

class ProfilePictureButtonView extends StatelessWidget {
  const ProfilePictureButtonView({super.key});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Get.toNamed(Routes.profile);
      },
      child: NPicture(ndkFlutter: Repository.ndkFlutter),
    );
  }
}

import 'package:couleur/controllers/auth_controller.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:couleur/repository.dart';
import 'package:ndk_flutter/ndk_flutter.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: NLogin(
              ndkFlutter: Repository.ndkFlutter,
              enablePubkeyLogin: false,
              onLoggedIn: () async {
                await AuthController.to.dropAnonymousAccount();
                Get.back();
                AuthController.to.update();
              },
            ),
          ),
        ),
      ),
    );
  }
}

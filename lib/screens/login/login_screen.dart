import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:couleur/repository.dart';
import 'package:nostr_widgets/nostr_widgets.dart';

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
              ndk: Repository.ndk,
              enablePubkeyLogin: false,
              onLoggedIn: () {
                Get.back();
                Repository.to.update();
              },
            ),
          ),
        ),
      ),
    );
  }
}

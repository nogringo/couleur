import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:couleur/repository.dart';
import 'package:couleur/controllers/theme_controller.dart';
import 'package:nostr_widgets/nostr_widgets.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final themeController = ThemeController.to;

    return Scaffold(
      appBar: AppBar(),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Align(
          alignment: Alignment.topCenter,
          child: ConstrainedBox(
            constraints: BoxConstraints(maxWidth: 500),
            child: Column(
              children: [
                NUserProfile(
                  ndk: Repository.ndk,
                  onLogout: () {
                    Get.back();
                    Repository.to.update();
                  },
                ),
                SizedBox(height: 16),
                GestureDetector(
                  onTap: () => themeController.toggleTheme(),
                  child: Card(
                    margin: EdgeInsets.all(0),
                    child: Obx(
                      () => ListTile(
                        leading: Icon(themeController.themeModeIcon),
                        title: Text('Theme Mode'),
                        subtitle: Text(themeController.themeModeText),
                        trailing: Icon(Icons.chevron_right),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

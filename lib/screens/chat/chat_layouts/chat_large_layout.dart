import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:couleur/repository.dart';
import 'package:couleur/screens/login/login_screen.dart';
import 'package:couleur/widgets/chat_view.dart';
import 'package:couleur/widgets/profile_picture_button_view.dart';
import 'package:couleur/widgets/send_field_view.dart';
import 'package:couleur/widgets/side_bar_view.dart';
import 'package:window_manager/window_manager.dart';
import 'package:couleur/l10n/app_localizations.dart';

class ChatLargeLayout extends StatelessWidget {
  const ChatLargeLayout({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Row(
          children: [
            SideBarView(),
            Expanded(
              child: GetBuilder<Repository>(
                builder: (c) {
                  return Column(
                    children: [
                      DragToMoveArea(
                        child: AppBar(
                          backgroundColor: Colors.transparent,
                          surfaceTintColor: Colors.transparent,
                          title: Obx(
                            () => Row(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Text(
                                  AppLocalizations.of(context)?.roomPrefix(
                                        Repository.to.selectedRoom.value,
                                      ) ??
                                      '#${Repository.to.selectedRoom.value}',
                                ),
                                IconButton(
                                  onPressed: () => Repository.to.toggleStarRoom(
                                    Repository.to.selectedRoom.value,
                                  ),
                                  icon: Icon(
                                    Repository.to.isRoomStarred(
                                          Repository.to.selectedRoom.value,
                                        )
                                        ? Icons.star_rounded
                                        : Icons.star_border_rounded,
                                    size: 20,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          actions: [
                            if (Repository.ndk.accounts.isNotLoggedIn)
                              TextButton(
                                onPressed: () {
                                  Get.to(LoginScreen());
                                },
                                child: Text(
                                  AppLocalizations.of(context)?.login ??
                                      "Login",
                                ),
                              ),
                            if (Repository.ndk.accounts.isLoggedIn)
                              ProfilePictureButtonView(),
                            SizedBox(width: 8),
                            if (!kIsWeb &&
                                (Platform.isWindows ||
                                    Platform.isLinux ||
                                    Platform.isMacOS))
                              SizedBox(
                                width: 154,
                                child: WindowCaption(
                                  brightness: Theme.of(context).brightness,
                                  backgroundColor: Colors.transparent,
                                ),
                              ),
                          ],
                        ),
                      ),
                      Expanded(child: ChatView()),
                      if (Repository.ndk.accounts.isLoggedIn) SendFieldView(),
                    ],
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

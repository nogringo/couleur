import 'package:get/get.dart';
import 'package:couleur/routes.dart';

/// A deep link opens a screen with nothing under it, so popping would leave the
/// app on a blank stack: fall back to the chat route.
void goBack() {
  if (Get.key.currentState?.canPop() ?? false) {
    Get.back();
    return;
  }
  Get.offAllNamed(Routes.chat);
}

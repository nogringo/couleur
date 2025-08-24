import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get_storage/get_storage.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final _storage = GetStorage();
  final _themeMode = ThemeMode.system.obs;

  ThemeMode get themeMode => _themeMode.value;

  @override
  void onInit() {
    super.onInit();
    final savedTheme = _storage.read('themeMode');
    if (savedTheme != null) {
      _themeMode.value = ThemeMode.values[savedTheme];
    }
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    _storage.write('themeMode', mode.index);
    Get.changeThemeMode(mode);
  }

  void toggleTheme() {
    switch (_themeMode.value) {
      case ThemeMode.system:
        setThemeMode(ThemeMode.light);
        break;
      case ThemeMode.light:
        setThemeMode(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        setThemeMode(ThemeMode.system);
        break;
    }
  }

  String get themeModeText {
    switch (_themeMode.value) {
      case ThemeMode.system:
        return 'System';
      case ThemeMode.light:
        return 'Light';
      case ThemeMode.dark:
        return 'Dark';
    }
  }

  IconData get themeModeIcon {
    switch (_themeMode.value) {
      case ThemeMode.system:
        return Icons.brightness_auto;
      case ThemeMode.light:
        return Icons.light_mode;
      case ThemeMode.dark:
        return Icons.dark_mode;
    }
  }
}

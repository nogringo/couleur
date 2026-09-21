import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController extends GetxController {
  static ThemeController get to => Get.find();

  final SharedPreferences _storage = Get.find();
  final _themeMode = ThemeMode.system.obs;

  ThemeMode get themeMode => _themeMode.value;

  @override
  void onInit() {
    super.onInit();
    final savedTheme = _storage.getInt('themeMode');
    if (savedTheme != null) {
      _themeMode.value = ThemeMode.values[savedTheme];
    }
  }

  void setThemeMode(ThemeMode mode) {
    _themeMode.value = mode;
    _storage.setInt('themeMode', mode.index);
    Get.changeThemeMode(mode);
  }
}

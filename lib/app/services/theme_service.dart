import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lockbloom/app/services/storage_service.dart';

class ThemeService extends GetxService {
  static const String _themeKey = 'theme_mode';
  
  final _themeMode = ThemeMode.system.obs;
  ThemeMode get theme => _themeMode.value;

  Future<ThemeService> init() async {
    final savedTheme = Get.find<StorageService>().read<String>(_themeKey);
    if (savedTheme != null) {
      _themeMode.value = ThemeMode.values.firstWhere(
        (mode) => mode.toString() == savedTheme,
        orElse: () => ThemeMode.system,
      );
    }
    return this;
  }

  void changeTheme(ThemeMode themeMode) {
    _themeMode.value = themeMode;
    Get.find<StorageService>().write(_themeKey, themeMode.toString());
    Get.changeThemeMode(themeMode);
  }

  void switchTheme() {
    switch (_themeMode.value) {
      case ThemeMode.light:
        changeTheme(ThemeMode.dark);
        break;
      case ThemeMode.dark:
        changeTheme(ThemeMode.system);
        break;
      case ThemeMode.system:
        changeTheme(ThemeMode.light);
        break;
    }
  }

  bool get isDarkMode {
    if (_themeMode.value == ThemeMode.system) {
      return Get.isPlatformDarkMode;
    }
    return _themeMode.value == ThemeMode.dark;
  }

  bool get isLightMode {
    if (_themeMode.value == ThemeMode.system) {
      return !Get.isPlatformDarkMode;
    }
    return _themeMode.value == ThemeMode.light;
  }
}
import 'package:flutter/material.dart';

class ThemeController {
  // 🔥 Stores the current theme (Light / Dark / System)
  static ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.system);

  // 🔵 For Settings Page → set specific theme (light/dark/system)
  static void setTheme(ThemeMode mode) {
    themeMode.value = mode;
  }

  // 🔥 For Profile Page → toggle Light <-> Dark
  static void toggleTheme() {
    if (themeMode.value == ThemeMode.dark) {
      themeMode.value = ThemeMode.light;
    } else {
      themeMode.value = ThemeMode.dark;
    }
  }
}

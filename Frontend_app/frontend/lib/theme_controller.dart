import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ThemeController {
  static ValueNotifier<ThemeMode> themeMode = ValueNotifier(ThemeMode.system);

  // Change theme
  static void setTheme(ThemeMode mode) async {
    themeMode.value = mode;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("theme", mode.name);
  }

  // Toggle Theme Light <-> Dark
  static void toggleTheme() {
    if (themeMode.value == ThemeMode.dark) {
      setTheme(ThemeMode.light);
    } else {
      setTheme(ThemeMode.dark);
    }
  }

  // LOAD saved theme when app starts
  static Future<void> loadTheme() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String saved = prefs.getString("theme") ?? "system";

    if (saved == "light") {
      themeMode.value = ThemeMode.light;
    } else if (saved == "dark") {
      themeMode.value = ThemeMode.dark;
    } else {
      themeMode.value = ThemeMode.system;
    }
  }
}

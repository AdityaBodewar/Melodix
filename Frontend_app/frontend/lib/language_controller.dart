import 'package:flutter/material.dart';

class LanguageController {
  static ValueNotifier<String> appLanguage = ValueNotifier("en");

  static void setLanguage(String lang) {
    appLanguage.value = lang;
  }
}

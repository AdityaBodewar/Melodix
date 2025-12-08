import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../language_controller.dart';

class LanguagePage extends StatefulWidget {
  const LanguagePage({Key? key}) : super(key: key);

  @override
  State<LanguagePage> createState() => _LanguagePageState();
}

class _LanguagePageState extends State<LanguagePage> {
  String selectedLang = "en"; // default English

  @override
  void initState() {
    super.initState();
    loadLanguage();
  }

  Future<void> loadLanguage() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    selectedLang = prefs.getString("app_language") ?? "en";
    setState(() {});
  }

  Future<void> saveLanguage(String lang) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setString("app_language", lang);

    LanguageController.setLanguage(lang);

    ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Language changed to $lang"))
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        title: const Text("Select Language"),
        backgroundColor: Colors.black,
      ),
      body: ListView(
        padding: const EdgeInsets.all(16),
        children: [

          _langTile("English", "en"),
          _langTile("Hindi", "hi"),
          _langTile("Marathi", "mr"),
          _langTile("Gujarati", "gu"),
          _langTile("Punjabi", "pa"),
          _langTile("Tamil", "ta"),

        ],
      ),
    );
  }

  Widget _langTile(String name, String code) {
    return RadioListTile(
      activeColor: Colors.blue,
      tileColor: const Color(0xFF1E1E1E),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      title: Text(name, style: const TextStyle(color: Colors.white)),
      value: code,
      groupValue: selectedLang,
      onChanged: (value) {
        setState(() => selectedLang = value.toString());
        saveLanguage(value.toString());
      },
    );
  }
}

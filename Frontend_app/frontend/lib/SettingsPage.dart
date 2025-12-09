import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/theme_controller.dart';
import 'package:audioplayers/audioplayers.dart';

class SettingsPage extends StatefulWidget {
  const SettingsPage({super.key});

  @override
  State<SettingsPage> createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  bool notificationsEnabled = true;
  double volume = 0.5;

  //  THEME always synced with ThemeController
  String themeMode = ThemeController.themeMode.value.name;

  final AudioPlayer globalPlayer = AudioPlayer(); // For controlling global volume

  @override
  void initState() {
    super.initState();
    loadSettings();

    // 🔥 Listen to theme changes everywhere
    ThemeController.themeMode.addListener(() {
      setState(() {
        themeMode = ThemeController.themeMode.value.name;
      });
    });
  }

  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      notificationsEnabled = prefs.getBool("notifications") ?? true;
      volume = prefs.getDouble("volume") ?? 0.5;

      // 🔥 Always match global theme
      themeMode = ThemeController.themeMode.value.name;
    });

    globalPlayer.setVolume(volume);
  }

  Future<void> saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setBool("notifications", notificationsEnabled);
    prefs.setDouble("volume", volume);
  }

  @override
  Widget build(BuildContext context) {
    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final cardColor = Theme.of(context).cardColor;
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;
    final subtitleColor = Theme.of(context).hintColor;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: Theme.of(context).appBarTheme.backgroundColor,
        title: Text("Settings", style: TextStyle(color: textColor)),
        iconTheme: IconThemeData(color: textColor),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [

          // ---------------- THEME SECTION ----------------
          Text("Theme", style: TextStyle(color: subtitleColor, fontSize: 16)),
          const SizedBox(height: 6),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Column(
              children: [

                // LIGHT MODE
                RadioListTile(
                  activeColor: Colors.blue,
                  title: Text("Light Theme", style: TextStyle(color: textColor)),
                  value: "light",
                  groupValue: themeMode,
                  onChanged: (value) {
                    setState(() => themeMode = value!);
                    ThemeController.setTheme(ThemeMode.light);
                    saveSettings();
                  },
                ),

                // DARK MODE
                RadioListTile(
                  activeColor: Colors.blue,
                  title: Text("Dark Theme", style: TextStyle(color: textColor)),
                  value: "dark",
                  groupValue: themeMode,
                  onChanged: (value) {
                    setState(() => themeMode = value!);
                    ThemeController.setTheme(ThemeMode.dark);
                    saveSettings();
                  },
                ),

                // SYSTEM MODE
                RadioListTile(
                  activeColor: Colors.blue,
                  title: Text("Follow System", style: TextStyle(color: textColor)),
                  value: "system",
                  groupValue: themeMode,
                  onChanged: (value) {
                    setState(() => themeMode = value!);
                    ThemeController.setTheme(ThemeMode.system);
                    saveSettings();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ---------------- VOLUME SECTION ----------------
          Text("Playback Volume",
              style: TextStyle(color: subtitleColor, fontSize: 16)),
          const SizedBox(height: 6),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
            ),

            child: Column(
              children: [
                Slider(
                  value: volume,
                  min: 0,
                  max: 1,
                  activeColor: Colors.blue,
                  onChanged: (value) {
                    setState(() => volume = value);
                    globalPlayer.setVolume(volume);
                    saveSettings();
                  },
                ),

                Text(
                  "Volume: ${(volume * 100).toInt()}%",
                  style: TextStyle(color: textColor),
                )
              ],
            ),
          ),

          const SizedBox(height: 20),

          // ---------------- NOTIFICATION SECTION ----------------
          Text("Notifications",
              style: TextStyle(color: subtitleColor, fontSize: 16)),
          const SizedBox(height: 6),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: cardColor,
              borderRadius: BorderRadius.circular(12),
            ),

            child: SwitchListTile(
              activeColor: Colors.blue,
              title: Text("App Notifications",
                  style: TextStyle(color: textColor)),
              value: notificationsEnabled,
              onChanged: (value) {
                setState(() => notificationsEnabled = value);
                saveSettings();
              },
            ),
          ),
        ],
      ),
    );
  }
}

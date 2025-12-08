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
  String themeMode = "system"; // light / dark / system

  final AudioPlayer globalPlayer = AudioPlayer(); // 🔥 global volume control

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  // LOAD SAVED SETTINGS
  Future<void> loadSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      notificationsEnabled = prefs.getBool("notifications") ?? true;
      volume = prefs.getDouble("volume") ?? 0.5;
      themeMode = prefs.getString("theme") ?? "system";
    });

    globalPlayer.setVolume(volume); // APPLY SAVED VOLUME
  }

  // SAVE SETTINGS
  Future<void> saveSettings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    prefs.setBool("notifications", notificationsEnabled);
    prefs.setDouble("volume", volume);
    prefs.setString("theme", themeMode);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      appBar: AppBar(
        backgroundColor: Colors.black,
        title: const Text("Settings"),
      ),

      body: ListView(
        padding: const EdgeInsets.all(16),

        children: [
          // 🔵 THEME SECTION --------------------
          const Text("Theme",
              style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 6),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),

            child: Column(
              children: [

                // LIGHT THEME
                RadioListTile(
                  activeColor: Colors.blue,
                  title: const Text("Light Theme",
                      style: TextStyle(color: Colors.white)),
                  value: "light",
                  groupValue: themeMode,
                  onChanged: (value) {
                    setState(() => themeMode = value!);
                    ThemeController.setTheme(ThemeMode.light); // APPLY
                    saveSettings();
                  },
                ),

                // DARK THEME
                RadioListTile(
                  activeColor: Colors.blue,
                  title: const Text("Dark Theme",
                      style: TextStyle(color: Colors.white)),
                  value: "dark",
                  groupValue: themeMode,
                  onChanged: (value) {
                    setState(() => themeMode = value!);
                    ThemeController.setTheme(ThemeMode.dark); // APPLY
                    saveSettings();
                  },
                ),

                // FOLLOW SYSTEM
                RadioListTile(
                  activeColor: Colors.blue,
                  title: const Text("Follow System",
                      style: TextStyle(color: Colors.white)),
                  value: "system",
                  groupValue: themeMode,
                  onChanged: (value) {
                    setState(() => themeMode = value!);
                    ThemeController.setTheme(ThemeMode.system); // APPLY
                    saveSettings();
                  },
                ),
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔵 VOLUME CONTROL ------------------
          const Text("Playback Volume",
              style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 6),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
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

                    globalPlayer.setVolume(volume); // 🔥 APPLY VOLUME
                    saveSettings();
                  },
                ),

                Text(
                  "Volume: ${(volume * 100).toInt()}%",
                  style: const TextStyle(color: Colors.white),
                )
              ],
            ),
          ),

          const SizedBox(height: 20),

          // 🔵 NOTIFICATIONS ---------------------
          const Text("Notifications",
              style: TextStyle(color: Colors.white70, fontSize: 16)),
          const SizedBox(height: 6),

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF1E1E1E),
              borderRadius: BorderRadius.circular(12),
            ),

            child: SwitchListTile(
              activeColor: Colors.blue,
              title: const Text("App Notifications",
                  style: TextStyle(color: Colors.white)),
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

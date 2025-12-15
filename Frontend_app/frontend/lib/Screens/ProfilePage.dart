import 'package:flutter/material.dart';
import 'package:frontend/AboutUsPage.dart';
import 'package:frontend/EditProfilePage.dart';
import 'package:frontend/HelpSupportPage.dart';
import 'package:frontend/LoginPage.dart';
import 'package:frontend/PrivacyPage.dart';
import 'package:frontend/SettingsPage.dart';
import 'package:frontend/TermsPage.dart';
import 'package:frontend/adminPanel/AddMusicForm.dart';
import 'package:frontend/main_screen.dart';
import 'package:frontend/theme_controller.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../MusicController.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({Key? key}) : super(key: key);

  @override
  State<Profilepage> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Profilepage> {
  String name = "Music Lover";
  String email = "musiclover@example.com";
  String role = "User";


  bool isProfileLoaded = false;

  Future<void> loadProfileData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();

    setState(() {
      name = prefs.getString("fullname") ?? "Music Lover";
      email = prefs.getString("email") ?? "musiclover@example.com";
      role = prefs.getString("role") ?? "User";

      isProfileLoaded = true;
    });
  }

  @override
  void initState() {
    super.initState();
    loadProfileData();
  }

  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    if (!isProfileLoaded) {
      return Scaffold(
        appBar: AppBar(
          title: const Text("Profile"),
          centerTitle: true,
        ),
        body: const Center(
          child: CircularProgressIndicator(),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 120),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 30),

            CircleAvatar(
              radius: 60,
              backgroundColor: Colors.blue,
              child: const Icon(Icons.person, size: 60, color: Colors.white),
            ),

            const SizedBox(height: 16),

            Text(
              name,
              style: TextStyle(
                color: textColor,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              email,
              style: TextStyle(
                color: Theme.of(context).hintColor,
                fontSize: 14,
              ),
            ),

            const SizedBox(height: 30),

            if (role == "Artist")
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                child: ListTile(
                  tileColor: Colors.blue.withOpacity(0.12), // 🔵 light blue background
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12),
                  ),
                  leading: const Icon(
                    Icons.library_music,
                    color: Colors.blue, // 🔵 blue icon
                  ),
                  title: const Text(
                    "Add Song",
                    style: TextStyle(
                      color: Colors.blue, // 🔵 blue text
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  trailing: const Icon(
                    Icons.chevron_right,
                    color: Colors.blue,
                  ),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(builder: (_) => AddMusicForm()),
                    );
                  },
                ),
              ),



            _buildProfileOption(Icons.edit, 'Edit Profile', () async {
              SharedPreferences prefs = await SharedPreferences.getInstance();

              String? email = prefs.getString("email");

              if (email == null || email.isEmpty) {
                // User not logged in
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text("Please login first to edit profile"),
                    backgroundColor: Colors.red,
                  ),
                );

                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const LoginPage()),
                );
                return;
              }

              // if user login alow editprofile
              // Navigator.push(
              //   context,
              //   MaterialPageRoute(builder: (_) => const EditProfilePage()),
              // );
            }

            ),


            _buildProfileOption(Icons.notifications, 'Notifications', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const SettingsPage()),
              );
            }),

            _buildProfileOption(Icons.privacy_tip, 'Privacy', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const PrivacyPage()),
              );
            }),

            _buildProfileOption(Icons.dark_mode, 'Theme', () {
              ThemeController.toggleTheme();
            }),

            _buildProfileOption(Icons.help, 'Help & Support', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const HelpSupportPage()),
              );
            }),

            _buildProfileOption(Icons.info, 'About', () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AboutUsPage()),
              );
            }),

            _buildProfileOption(Icons.policy, "Terms & Condition", () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const TermsPage()),
              );
            }),

            // LOGOUT
            _buildProfileOption(Icons.logout, "Logout", showLogoutConfirmDialog),

            const SizedBox(height: 20),
          ],
        ),
      ),
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;
    final subtitleColor = isDark ? Colors.grey : Colors.black54;

    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(
        title,
        style: TextStyle(color: textColor, fontSize: 16),
      ),
      trailing: Icon(Icons.chevron_right, color: subtitleColor),
      onTap: onTap,
    );
  }


  void showLogoutConfirmDialog() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Logout"),
          content: const Text("Are you sure you want to logout?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            ElevatedButton(
              onPressed: () async {
                Navigator.pop(context);
                await logoutUser();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.red,
              ),
              child: const Text("Yes"),
            ),
          ],
        );
      },
    );
  }

  Future<void> logoutUser() async {
    await MusicController.reset();

    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (_) => const MainScreen()),
          (route) => false,
    );

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Logged out successfully")),
    );
  }

}

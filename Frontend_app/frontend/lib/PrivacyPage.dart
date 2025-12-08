import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Privacy Policy")),
      backgroundColor: Colors.black,
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [

            Text("Data We Collect",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "• Name, Email, Profile Info\n"
                  "• Music Preferences (likes, albums, history)",
              style: TextStyle(color: Colors.white70),
            ),

            SizedBox(height: 20),
            Text("No Data Selling",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "We do not share or sell your personal data with any third-party.",
              style: TextStyle(color: Colors.white70),
            ),

            SizedBox(height: 20),
            Text("Offline Downloads",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "Downloaded songs are stored only in your device, not on our servers.",
              style: TextStyle(color: Colors.white70),
            ),

            SizedBox(height: 20),
            Text("Permissions",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "• Internet\n• Storage (for downloads)",
              style: TextStyle(color: Colors.white70),
            ),

            SizedBox(height: 20),
            Text("Contact Us",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "For privacy issues, contact support in Help & Support section.",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

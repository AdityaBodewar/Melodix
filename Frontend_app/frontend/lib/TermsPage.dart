import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Terms & Conditions")),
      backgroundColor: Colors.black,

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [

            Text("1. Acceptance of Terms",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "By using this app, you agree to follow all the terms and conditions mentioned here.",
              style: TextStyle(color: Colors.white70),
            ),

            SizedBox(height: 20),
            Text("2. Use of the App",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "This app is only for personal and non-commercial use. Users must not misuse or hack the app.",
              style: TextStyle(color: Colors.white70),
            ),

            SizedBox(height: 20),
            Text("3. Music Content",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "All songs are for streaming within the app. Offline downloads are only for personal use.",
              style: TextStyle(color: Colors.white70),
            ),

            SizedBox(height: 20),
            Text("4. User Responsibilities",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "Users are responsible for account safety and providing correct information.",
              style: TextStyle(color: Colors.white70),
            ),

            SizedBox(height: 20),
            Text("5. App Updates",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "We may update or modify the app anytime. Continued use means you accept these updates.",
              style: TextStyle(color: Colors.white70),
            ),

            SizedBox(height: 20),
            Text("6. Limitation of Liability",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "The app is not responsible for bugs, downtime, or data loss. Use at your own risk.",
              style: TextStyle(color: Colors.white70),
            ),

            SizedBox(height: 20),
            Text("7. Changes to Terms",
                style: TextStyle(color: Colors.white, fontSize: 18, fontWeight: FontWeight.bold)),
            SizedBox(height: 8),
            Text(
              "We may update these terms anytime. Users will be notified inside the app.",
              style: TextStyle(color: Colors.white70),
            ),
          ],
        ),
      ),
    );
  }
}

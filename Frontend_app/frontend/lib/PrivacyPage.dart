import 'package:flutter/material.dart';

class PrivacyPage extends StatelessWidget {
  const PrivacyPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bgColor = theme.scaffoldBackgroundColor;
    final primaryText = theme.textTheme.bodyLarge?.color;
    final secondaryText = theme.textTheme.bodyMedium?.color;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Privacy Policy"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _sectionTitle("Data We Collect", primaryText),
            _sectionText(
              "• Name, Email, Profile Info\n"
                  "• Music Preferences (likes, albums, history)",
              secondaryText,
            ),

            const SizedBox(height: 24),

            _sectionTitle("No Data Selling", primaryText),
            _sectionText(
              "We do not share or sell your personal data with any third-party.",
              secondaryText,
            ),

            const SizedBox(height: 24),

            _sectionTitle("Offline Downloads", primaryText),
            _sectionText(
              "Downloaded songs are stored only on your device, not on our servers.",
              secondaryText,
            ),

            const SizedBox(height: 24),

            _sectionTitle("Permissions", primaryText),
            _sectionText(
              "• Internet\n• Storage (for downloads)",
              secondaryText,
            ),

            const SizedBox(height: 24),

            _sectionTitle("Contact Us", primaryText),
            _sectionText(
              "For privacy-related concerns, please contact us through the Help & Support section.",
              secondaryText,
            ),

            const SizedBox(height: 30),

            Center(
              child: Text(
                "Your privacy matters to us 💙",
                style: TextStyle(
                  color: theme.colorScheme.primary,
                  fontSize: 15,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }


  Widget _sectionTitle(String text, Color? color) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _sectionText(String text, Color? color) {
    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        text,
        style: TextStyle(
          color: color?.withOpacity(0.8),
          fontSize: 15,
        ),
      ),
    );
  }
}

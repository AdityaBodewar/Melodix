import 'package:flutter/material.dart';

class AboutUsPage extends StatelessWidget {
  const AboutUsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    final bgColor = Theme.of(context).scaffoldBackgroundColor;
    final primaryText = Theme.of(context).textTheme.bodyLarge?.color;
    final secondaryText = Theme.of(context).textTheme.bodyMedium?.color;
    final accentColor = Theme.of(context).colorScheme.primary;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("About Us"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            Text(
              "MusicVibe – Your Personal Music World",
              style: TextStyle(
                color: primaryText,
                fontSize: 22,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 16),

            Text(
              "MusicVibe is a modern and fast music streaming application "
                  "designed to provide a smooth, high-quality, and user-friendly "
                  "listening experience. Our goal is to make music more enjoyable "
                  "and easily accessible for everyone.",
              style: TextStyle(
                color: secondaryText?.withOpacity(0.8),
                fontSize: 16,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "Our Mission",
              style: TextStyle(
                color: primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "We believe music is not just entertainment, but emotion. "
                  "That's why we created MusicVibe with a simple interface, "
                  "intelligent features, and seamless playback to enhance your "
                  "music experience.",
              style: TextStyle(
                color: secondaryText?.withOpacity(0.8),
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "What We Offer",
              style: TextStyle(
                color: primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "• High-quality music streaming\n"
                  "• Offline downloads\n"
                  "• Personalized playlists\n"
                  "• Clean and beautiful UI\n"
                  "• Fast search & smooth playback\n"
                  "• Regular updates",
              style: TextStyle(
                color: secondaryText?.withOpacity(0.8),
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 24),

            Text(
              "Contact Us",
              style: TextStyle(
                color: primaryText,
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 8),

            Text(
              "Email: pbhandare239@gmail.com\n"
                  "Linkedin: https://www.linkedin.com/in/priyanshu-bhandare/\n"
                  "Website: www.musicvibe.app",
              style: TextStyle(
                color: secondaryText?.withOpacity(0.8),
                fontSize: 15,
              ),
            ),

            const SizedBox(height: 30),

            Center(
              child: Text(
                "Thank you for using Melodix 💙",
                style: TextStyle(
                  color: accentColor,
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

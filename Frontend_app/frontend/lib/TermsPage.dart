import 'package:flutter/material.dart';

class TermsPage extends StatelessWidget {
  const TermsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final bgColor = theme.scaffoldBackgroundColor;
    final primaryText = theme.textTheme.bodyLarge?.color;
    final secondaryText = theme.textTheme.bodyMedium?.color;

    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        title: const Text("Terms & Conditions"),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            _title("1. Acceptance of Terms", primaryText),
            _content(
              "By using this app, you agree to follow all the terms and conditions mentioned here.",
              secondaryText,
            ),

            const SizedBox(height: 24),

            _title("2. Use of the App", primaryText),
            _content(
              "This app is only for personal and non-commercial use. Users must not misuse or hack the app.",
              secondaryText,
            ),

            const SizedBox(height: 24),

            _title("3. Music Content", primaryText),
            _content(
              "All songs are for streaming within the app. Offline downloads are only for personal use.",
              secondaryText,
            ),

            const SizedBox(height: 24),

            _title("4. User Responsibilities", primaryText),
            _content(
              "Users are responsible for account safety and providing correct information.",
              secondaryText,
            ),

            const SizedBox(height: 24),

            _title("5. App Updates", primaryText),
            _content(
              "We may update or modify the app anytime. Continued use means you accept these updates.",
              secondaryText,
            ),

            const SizedBox(height: 24),

            _title("6. Limitation of Liability", primaryText),
            _content(
              "The app is not responsible for bugs, downtime, or data loss. Use at your own risk.",
              secondaryText,
            ),

            const SizedBox(height: 24),

            _title("7. Changes to Terms", primaryText),
            _content(
              "We may update these terms anytime. Users will be notified inside the app.",
              secondaryText,
            ),

            const SizedBox(height: 30),

            Center(
              child: Text(
                "By continuing, you agree to these terms 📜",
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


  Widget _title(String text, Color? color) {
    return Text(
      text,
      style: TextStyle(
        color: color,
        fontSize: 18,
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _content(String text, Color? color) {
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

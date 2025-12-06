import 'package:flutter/material.dart';

class Profilepage extends StatefulWidget {
  const Profilepage({Key? key}) : super(key: key);

  @override
  State<Profilepage> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Profilepage> {
  String name = 'Music Lover';
  String email = 'musiclover@example.com';
  bool isDarkTheme = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Profile',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: SingleChildScrollView(
        child: Column(
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
              style: const TextStyle(
                color: Colors.white,
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              email,
              style: TextStyle(color: Colors.grey[400], fontSize: 14),
            ),
            const SizedBox(height: 30),
            _buildProfileOption(Icons.edit, 'Edit Profile', () {
              _showEditDialog();
            }),
            _buildProfileOption(Icons.notifications, 'Notifications', () {}),
            _buildProfileOption(Icons.privacy_tip, 'Privacy', () {}),
            _buildProfileOption(Icons.language, 'Language', () {}),
            _buildProfileOption(Icons.dark_mode, 'Theme', () {
              setState(() {
                isDarkTheme = !isDarkTheme;
              });
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content: Text(
                    isDarkTheme ? 'Dark Theme Enabled' : 'Light Theme Enabled',
                  ),
                ),
              );
            }),
            _buildProfileOption(Icons.help, 'Help & Support', () {}),
            _buildProfileOption(Icons.info, 'About', () {}),
            _buildProfileOption(Icons.logout, 'Logout', () {
              // Add logout functionality
            }),
          ],
        ),
      ),
      backgroundColor: isDarkTheme ? const Color(0xFF121212) : Colors.white,
    );
  }

  Widget _buildProfileOption(IconData icon, String title, VoidCallback onTap) {
    return ListTile(
      leading: Icon(icon, color: Colors.blue),
      title: Text(title, style: TextStyle(color: isDarkTheme ? Colors.white : Colors.black)),
      trailing: Icon(Icons.chevron_right, color: isDarkTheme ? Colors.grey : Colors.black54),
      onTap: onTap,
    );
  }

  void _showEditDialog() {
    TextEditingController nameController = TextEditingController(text: name);
    TextEditingController emailController = TextEditingController(text: email);

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Edit Profile'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: nameController,
                decoration: const InputDecoration(labelText: 'Name'),
              ),
              TextField(
                controller: emailController,
                decoration: const InputDecoration(labelText: 'Email'),
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(context); // Close dialog
              },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  name = nameController.text;
                  email = emailController.text;
                });
                Navigator.pop(context);
              },
              child: const Text('Save'),
            ),
          ],
        );
      },
    );
  }
}

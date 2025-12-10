import 'dart:io';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:frontend/handleApi/ApiService .dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({Key? key}) : super(key: key);

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  TextEditingController nameController = TextEditingController();
  TextEditingController emailController = TextEditingController();

  String? profileImagePath;
  String oldEmail = "";
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    loadStoredUser();
  }

  // Load existing stored user data
  Future<void> loadStoredUser() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      nameController.text = prefs.getString("fullname") ?? "";
      emailController.text = prefs.getString("email") ?? "";
      oldEmail = prefs.getString("email") ?? "";
      profileImagePath = prefs.getString("profileImage");
    });
  }

  // Pick image
  Future<void> pickImage() async {
    final picker = ImagePicker();
    final picked = await picker.pickImage(source: ImageSource.gallery);

    if (picked != null) {
      setState(() {
        profileImagePath = picked.path;
      });
    }
  }

  // SAVE PROFILE
  Future<void> saveProfile() async {
    setState(() => isLoading = true);

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String role = prefs.getString("role") ?? "";

    final res = await ApiService.updateProfile(
      oldEmail: oldEmail,
      fullname: nameController.text,
      newEmail: emailController.text.isEmpty ? oldEmail : emailController.text, // FIXED
      role: role,
      imagePath: profileImagePath,
    );

    setState(() => isLoading = false);

    if (res["status"] == 200) {
      await prefs.setString("fullname", nameController.text);
      await prefs.setString("email", emailController.text.isEmpty ? oldEmail : emailController.text);

      if (profileImagePath != null) {
        await prefs.setString("profileImage", profileImagePath!);
      }

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Profile updated successfully")),
      );

      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res["data"]["message"] ?? "Update failed")),
      );
    }
  }



  @override
  Widget build(BuildContext context) {
    final textColor = Theme.of(context).textTheme.bodyMedium?.color;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Profile", style: TextStyle(fontWeight: FontWeight.bold)),
      ),

      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            children: [

              // PROFILE IMAGE
              GestureDetector(
                onTap: pickImage,
                child: CircleAvatar(
                  radius: 60,
                  backgroundColor: Colors.blue,
                  backgroundImage:
                  profileImagePath != null ? FileImage(File(profileImagePath!)) : null,
                  child: profileImagePath == null
                      ? const Icon(Icons.camera_alt, color: Colors.white, size: 40)
                      : null,
                ),
              ),

              const SizedBox(height: 30),

              // NAME FIELD
              TextField(
                controller: nameController,
                decoration: InputDecoration(
                  labelText: "Full Name",
                  labelStyle: TextStyle(color: textColor),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 20),

              // EMAIL FIELD
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(color: textColor),
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
                ),
              ),

              const SizedBox(height: 30),

              // SAVE BUTTON
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : saveProfile,
                  style: ElevatedButton.styleFrom(
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    backgroundColor: Colors.blue,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Save",
                    style: TextStyle(color: Colors.white, fontSize: 16),
                  ),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

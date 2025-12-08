import 'package:flutter/material.dart';
import 'package:frontend/adminPanel/AddMusicForm.dart';

class AdminLoginPage extends StatefulWidget {
  const AdminLoginPage({super.key});

  @override
  State<AdminLoginPage> createState() => _AdminLoginPageState();
}

class _AdminLoginPageState extends State<AdminLoginPage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController username = TextEditingController();
  final TextEditingController password = TextEditingController();

  bool hidePassword = true;

  final String adminUser = "priyanshu_tamanna";
  final String adminPass = "14april";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),

          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [

                const Text(
                  "Admin Login",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 30),

                // Username
                TextFormField(
                  controller: username,
                  validator: (value) {
                    if (value!.isEmpty) return "Enter username";
                    return null;
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Username",
                    labelStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.person, color: Colors.grey),
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 16),

                // Password
                TextFormField(
                  controller: password,
                  obscureText: hidePassword,
                  validator: (value) {
                    if (value!.isEmpty) return "Enter password";
                    return null;
                  },
                  style: const TextStyle(color: Colors.white),
                  decoration: InputDecoration(
                    labelText: "Password",
                    labelStyle: const TextStyle(color: Colors.grey),
                    prefixIcon: const Icon(Icons.lock, color: Colors.grey),
                    suffixIcon: IconButton(
                      icon: Icon(
                        hidePassword ? Icons.visibility_off : Icons.visibility,
                        color: Colors.grey,
                      ),
                      onPressed: () {
                        setState(() {
                          hidePassword = !hidePassword;
                        });
                      },
                    ),
                    filled: true,
                    fillColor: const Color(0xFF1E1E1E),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),

                const SizedBox(height: 25),

                // Login Button
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      if (_formKey.currentState!.validate()) {

                        if (username.text == adminUser &&
                            password.text == adminPass) {

                          // SUCCESS
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                " Admin Login Successful!",
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                              backgroundColor: Colors.green,
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 2),
                            ),
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const AddMusicForm(),
                            ),
                          );

                        } else {
                          // WRONG CREDENTIALS
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                " Invalid Username or Password!",
                                style: TextStyle(fontSize: 16),
                              ),
                              backgroundColor: Colors.red,
                              behavior: SnackBarBehavior.floating,
                              duration: Duration(seconds: 2),
                            ),
                          );
                        }
                      }
                    },

                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      padding: const EdgeInsets.symmetric(vertical: 14),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),

                    child: const Text(
                      "Login",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

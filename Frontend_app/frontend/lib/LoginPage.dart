import 'package:flutter/material.dart';
import 'package:frontend/handleApi/ApiService .dart';
import 'package:frontend/Screens/HomePage.dart';
import 'package:frontend/adminPanel/adminloginpage.dart';
import 'package:frontend/Registerpage.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'main_screen.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();


  bool hidePassword = true;
  bool isLoading = false;

  Future<void> handleLogin() async {
    if (isLoading) return;

    String mail = email.text.trim();
    String pass = password.text.trim();

    if (mail.isEmpty || pass.isEmpty) {
      showError("Email and Password required");
      return;
    }

    setState(() => isLoading = true);

    final result = await ApiService.login_flutter(email: mail, password: pass);

    setState(() => isLoading = false);

    print(" FINAL RESULT = $result");

    final status = result["status"];
    final data = result["data"];

    print("STATUS = $status");
    print("DATA = $data");

    if (status == 401) {
      String msg = (data["message"] ?? data["error"] ?? "")
          .toString()
          .trim()
          .toLowerCase();

      if (msg.contains("email") && msg.contains("not") && msg.contains("registered")) {
        showError("Email not registered");
      }
      else if (msg.contains("wrong") && msg.contains("password")) {
        showError("Wrong Password");
      }
      else {
        showError("Login failed");
      }
      return;
    }




    if (status == 500) {
      showError(data["error"] ?? "Server error");
      return;
    }


    if (status == 200) {
      final role = data["Role"] ?? "";
      final token = data["Token"] ?? "";

      SharedPreferences prefs = await SharedPreferences.getInstance();
      await prefs.setString("token", token);
      await prefs.setString("role", role);

      // await prefs.setString("fullname", data["Fullname"] ?? "");
      // await prefs.setString("email", data["Email"] ?? "");
      //
      print("FULLNAME FROM BACKEND = ${data["Fullname"]}");
      print("EMAIL FROM BACKEND = ${data["Email"]}");


      showSuccess("$role Login Successfully!");

      if (role == "Admin") {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => const AdminLoginPage()),
        );
      } else {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (_) => MainScreen()),
        );
      }

      return;
    }

    showError("Unexpected error occurred");
  }



  void showError(String msg) {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }


  void showSuccess(String msg) {
    FocusScope.of(context).unfocus();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }



  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      backgroundColor: Theme.of(context).scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome Back",
                style: TextStyle(
                  color: isDark ? Colors.white : Colors.black,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 30),

              _buildInputField(
                controller: email,
                label: "Email",
                icon: Icons.email,
              ),
              const SizedBox(height: 20),

              _buildPasswordField(),
              const SizedBox(height: 30),

              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: isLoading ? null : handleLogin,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.blue,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  child: isLoading
                      ? const CircularProgressIndicator(color: Colors.white)
                      : const Text(
                    "Login",
                    style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.bold),
                  ),
                ),
              ),

              const SizedBox(height: 20),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Don't have an account?",
                      style: TextStyle(
                        color: isDark ? Colors.white70 : Colors.black54,
                      )),
                  const SizedBox(width: 5),
                  GestureDetector(
                    onTap: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(builder: (_) => const RegisterPage()),
                      );
                    },
                    child: const Text(
                      "Register",
                      style:
                      TextStyle(color: Colors.blue, fontWeight: FontWeight.bold),
                    ),
                  )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildInputField({
    required TextEditingController controller,
    required String label,
    required IconData icon,
  }) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: controller,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : Colors.black54,
        ),
        prefixIcon: Icon(
          icon,
          color: isDark ? Colors.white70 : Colors.grey,
        ),
        filled: true,
        fillColor: isDark
            ? const Color(0xFF1E1E1E) // proper dark input bg
            : Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }


  Widget _buildPasswordField() {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return TextField(
      controller: password,
      obscureText: hidePassword,
      style: TextStyle(
        color: isDark ? Colors.white : Colors.black,
      ),
      decoration: InputDecoration(
        labelText: "Password",
        labelStyle: TextStyle(
          color: isDark ? Colors.white70 : Colors.black54,
        ),
        prefixIcon: Icon(
          Icons.lock,
          color: isDark ? Colors.white70 : Colors.grey,
        ),
        suffixIcon: IconButton(
          icon: Icon(
            hidePassword ? Icons.visibility_off : Icons.visibility,
            color: isDark ? Colors.white70 : Colors.grey,
          ),
          onPressed: () => setState(() => hidePassword = !hidePassword),
        ),
        filled: true,
        fillColor: isDark
            ? const Color(0xFF1E1E1E)
            : Colors.grey.shade200,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12),
        ),
      ),
    );
  }

}

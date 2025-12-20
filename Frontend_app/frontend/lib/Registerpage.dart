import 'package:flutter/material.dart';
import 'package:frontend/LoginPage.dart';
import 'package:frontend/Screens/HomePage.dart';
import 'package:frontend/handleApi/ApiService .dart';
import 'package:frontend/main_screen.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  final _formKeyUser = GlobalKey<FormState>();
  final _formKeyArtist = GlobalKey<FormState>();

  // USER TEXT FIELDS
  final TextEditingController fullName = TextEditingController();
  final TextEditingController username = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController password = TextEditingController();
  bool hidePassword = true;

  // ARTIST TEXT FIELDS
  final TextEditingController artistName = TextEditingController();
  final TextEditingController stageName = TextEditingController();
  final TextEditingController artistType = TextEditingController();
  final TextEditingController artistEmail = TextEditingController();
  final TextEditingController artistPassword = TextEditingController();
  bool hideArtistPassword = true;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }


  Future<void> registerUser() async {
    if (!_formKeyUser.currentState!.validate()) return;

    final response = await ApiService.registerUser(
      fullname: fullName.text.trim(),
      username: username.text.trim(),
      email: email.text.trim(),
      password: password.text.trim(),
    );

    if (response["error"] != null) {
      _showError(response["error"]);
      return;
    }

    final message = response["message"]?.toString() ?? "";

    if (message == "user registered Successfully") {
      _showSuccess(message);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    }
    else {
      _showError(message.isEmpty ? "Registration failed" : message);
    }
  }


  Future<void> registerArtist() async {
    if (!_formKeyArtist.currentState!.validate()) return;

    final response = await ApiService.registerArtist(
      fullname: artistName.text.trim(),
      username: stageName.text.trim(),
      email: artistEmail.text.trim(),
      password: artistPassword.text.trim(),
      type: artistType.text.trim(),
    );

    if (response["error"] != null) {
      _showError(response["error"]);
      return;
    }

    final message = response["message"]?.toString() ?? "";

    if (message == "Artist registered Successfully") {
      _showSuccess(message);
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (_) => const LoginPage()),
      );
    } else {
      _showError(message.isEmpty ? "Registration failed" : message);
    }
  }




  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return WillPopScope(
      onWillPop: () async => false,
      child: Scaffold(
        backgroundColor: isDark ? Colors.black : Colors.white,
        appBar: AppBar(
          automaticallyImplyLeading: false,
          backgroundColor: isDark ? Colors.black : Colors.white,
          elevation: 0,
          bottom: TabBar(
            controller: _tabController,
            indicatorColor: Colors.blue,
            labelColor: isDark ? Colors.white : Colors.black,
            unselectedLabelColor: Colors.grey,
            tabs: const [
              Tab(text: "User Register"),
              Tab(text: "Artist Register"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            _buildUserRegisterForm(isDark),
            _buildArtistRegisterForm(isDark),
          ],
        ),
      ),
    );
  }



  Widget _buildUserRegisterForm(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKeyUser,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Create User Account",
                style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            _field(fullName, "Full Name", Icons.person),
            _space(),
            _field(username, "Username", Icons.account_circle),
            _space(),
            _field(email, "Email", Icons.email,
                validator: (v) => v!.contains("@") ? null : "Invalid Email"),
            _space(),
            _passwordField(),
            _space(height: 30),

            _button("Register", registerUser),
            _space(),

            _loginRedirect(isDark),
          ],
        ),
      ),
    );
  }


  Widget _buildArtistRegisterForm(bool isDark) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(24),
      child: Form(
        key: _formKeyArtist,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text("Register as Artist",
                style: TextStyle(
                    color: isDark ? Colors.white : Colors.black,
                    fontSize: 26,
                    fontWeight: FontWeight.bold)),
            const SizedBox(height: 20),

            _field(artistName, "Artist Full Name", Icons.person),
            _space(),
            _field(stageName, "Username", Icons.music_note),
            _space(),
            _field(artistType, "Artist Type (Rap, Pop...)", Icons.category),
            _space(),
            _field(artistEmail, "Email", Icons.email,
                validator: (v) => v!.contains("@") ? null : "Invalid Email"),
            _space(),
            _artistPasswordField(),
            _space(height: 30),

            _button("Register", registerArtist),
          ],
        ),
      ),
    );
  }


  Widget _field(TextEditingController c, String label, IconData icon,
      {FormFieldValidator<String>? validator}) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    return TextFormField(
      controller: c,
      validator: validator ?? (v) => v!.isEmpty ? "Required" : null,
      style: TextStyle(color: isDark ? Colors.white : Colors.black),
      decoration: InputDecoration(
        labelText: label,
        prefixIcon: Icon(icon, color: Colors.grey),
        filled: true,
        fillColor: isDark ? Colors.grey.shade900 : Colors.grey.shade200,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _passwordField() {
    return TextFormField(
      controller: password,
      obscureText: hidePassword,
      validator: (v) => v!.length < 6 ? "Password too weak" : null,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon: Icon(hidePassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () => setState(() => hidePassword = !hidePassword),
        ),
        labelText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _artistPasswordField() {
    return TextFormField(
      controller: artistPassword,
      obscureText: hideArtistPassword,
      validator: (v) => v!.length < 6 ? "Password too weak" : null,
      decoration: InputDecoration(
        prefixIcon: const Icon(Icons.lock),
        suffixIcon: IconButton(
          icon:
          Icon(hideArtistPassword ? Icons.visibility_off : Icons.visibility),
          onPressed: () =>
              setState(() => hideArtistPassword = !hideArtistPassword),
        ),
        labelText: "Password",
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  Widget _button(String text, Function() onTap) {
    return SizedBox(
      width: double.infinity,
      child: ElevatedButton(
        onPressed: onTap,
        style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            padding: const EdgeInsets.symmetric(vertical: 14),
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12))),
        child: Text(text,
            style: const TextStyle(fontSize: 16, color: Colors.white)),
      ),
    );
  }

  Widget _loginRedirect(bool isDark) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text("Already have an account?",
            style: TextStyle(color: isDark ? Colors.white70 : Colors.black54)),
         TextButton(onPressed: () => Navigator.pushAndRemoveUntil(
         context,
               MaterialPageRoute(builder: (_) => const LoginPage()),
                (route) => false,
    ),

    child: const Text("Login", style: TextStyle(color: Colors.blue)),
        )
      ],
    );
  }

  Widget _space({double height = 16}) => SizedBox(height: height);

  void _showSuccess(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.green),
    );
  }

  void _showError(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: Colors.red),
    );
  }
}

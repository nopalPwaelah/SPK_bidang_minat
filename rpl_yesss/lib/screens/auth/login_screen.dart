import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../admin/admin_dashboard_screen.dart';
import '../users/user_dashboard_screen.dart';
import 'register_screen.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {

  final email = TextEditingController();
  final password = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void login() async {
    // 🔒 VALIDASI
    if (email.text.isEmpty || password.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Email & Password wajib diisi")),
      );
      return;
    }

    setState(() => isLoading = true);

    try {
      final res = await ApiService.login(email.text, password.text);

      setState(() => isLoading = false);

      // ✅ CEK TOKEN
      if (res["access_token"] != null) {

        // 🔥 SIMPAN TOKEN
        ApiService.token = res["access_token"];

        // 🔥 AMANKAN ROLE (INT / STRING)
        int role = int.tryParse(res["role"].toString()) ?? 2;

        print("LOGIN SUCCESS → ROLE: $role");

        // 🔥 NAVIGASI
        if (role == 1) {
          // ADMIN
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const AdminDashboard()),
          );
        } else {
          // USER
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => const UserDashboard()),
          );
        }

      } else {
        // ❌ LOGIN GAGAL
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              res["detail"] ?? res["error"] ?? "Login gagal"
            ),
          ),
        );
      }

    } catch (e) {
      setState(() => isLoading = false);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            e.toString().replaceAll("Exception: ", "")
          ),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            // EMAIL
            TextField(
              controller: email,
              decoration: const InputDecoration(
                labelText: "Email",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 12),

            // PASSWORD
            TextField(
              controller: password,
              obscureText: true,
              decoration: const InputDecoration(
                labelText: "Password",
                border: OutlineInputBorder(),
              ),
            ),

            const SizedBox(height: 20),

            // BUTTON LOGIN
            isLoading
                ? const CircularProgressIndicator()
                : SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: login,
                      child: const Text("Login"),
                    ),
                  ),

            const SizedBox(height: 10),

            // REGISTER
            TextButton(
              onPressed: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (_) => const RegisterScreen()),
                );
              },
              child: const Text("Belum punya akun? Register"),
            )
          ],
        ),
      ),
    );
  }
}
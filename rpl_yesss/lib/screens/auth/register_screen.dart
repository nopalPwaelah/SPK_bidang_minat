import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../../widgets/custom_button.dart';
import '../../widgets/custom_textfield.dart';

class RegisterScreen extends StatefulWidget {
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {

  final username = TextEditingController();
  final email = TextEditingController();
  final password = TextEditingController();

  bool isLoading = false;

  @override
  void dispose() {
    username.dispose();
    email.dispose();
    password.dispose();
    super.dispose();
  }

  void register() async {
  if (username.text.isEmpty ||
      email.text.isEmpty ||
      password.text.isEmpty) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Semua field wajib diisi")),
    );
    return;
  }

  if (!email.text.contains("@")) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Format email tidak valid")),
    );
    return;
  }

  if (password.text.length < 6) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Password minimal 6 karakter")),
    );
    return;
  }

  setState(() => isLoading = true);

  try {
    final res = await ApiService.register(
      username.text,
      email.text,
      password.text,
    );

    setState(() => isLoading = false);

    // ✅ SUCCESS
    if (res["msg"] != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(res["msg"])),
      );

      Navigator.pop(context);
    }

  } catch (e) {
    setState(() => isLoading = false);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(e.toString().replaceAll("Exception: ", "")),
      ),
    );
  }
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Register")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            CustomTextField(
              controller: username,
              label: "Username",
            ),

            const SizedBox(height: 10),

            CustomTextField(
              controller: email,
              label: "Email",
            ),

            const SizedBox(height: 10),

            CustomTextField(
              controller: password,
              label: "Password",
              isPassword: true,
            ),

            const SizedBox(height: 20),

            isLoading
                ? const CircularProgressIndicator()
                : CustomButton(
                    text: "Register",
                    onPressed: register,
                  ),
          ],
        ),
      ),
    );
  }
}
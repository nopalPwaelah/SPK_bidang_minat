import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../auth/login_screen.dart';
import '../sidebar/user_sidebar.dart';
import 'input_nilai_screen.dart';
import 'hasil_screen.dart';

class UserDashboard extends StatelessWidget {
  const UserDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Mahasiswa"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // 🔥 HAPUS TOKEN
              ApiService.token = null;

              // 🔥 KEMBALI KE LOGIN (CLEAR SEMUA STACK)
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          )
        ],
      ),

      // 🔥 SIDEBAR
      drawer: const UserSidebar(),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [

            const Align(
              alignment: Alignment.centerLeft,
              child: Text(
                "Menu Utama",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
            ),

            const SizedBox(height: 16),

            _menuCard(
              context,
              title: "Input Nilai",
              icon: Icons.edit,
              color: Colors.blue,
              screen: const InputNilaiScreen(),
            ),

            const SizedBox(height: 12),

            _menuCard(
              context,
              title: "Hasil Rekomendasi",
              icon: Icons.analytics,
              color: Colors.green,
              screen: const HasilScreen(),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 FIX NAVIGASI
  Widget _menuCard(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Widget screen,
  }) {
    return Card(
      elevation: 4,
      child: ListTile(
        leading: CircleAvatar(
          backgroundColor: color,
          child: Icon(icon, color: Colors.white),
        ),
        title: Text(title),
        trailing: const Icon(Icons.arrow_forward_ios),
        onTap: () {
          // 🔥 PENTING: gunakan ini biar tidak numpuk
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (_) => screen),
          );
        },
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../auth/login_screen.dart';
import '../users/user_dashboard_screen.dart';
import '../users/input_nilai_screen.dart';
import '../users/hasil_screen.dart';
import '../users/riwayat_screen.dart';
import '../users/pesan_dosen_screen.dart';

class UserSidebar extends StatelessWidget {
  const UserSidebar({super.key});

  void navigate(BuildContext context, Widget page) {
    Navigator.pop(context);
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => page),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          const UserAccountsDrawerHeader(
            accountName: Text("Mahasiswa"),
            accountEmail: Text("user@gmail.com"),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.person),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () => navigate(context, const UserDashboard()),
          ),

          ListTile(
            leading: const Icon(Icons.edit),
            title: const Text("Input Nilai"),
            onTap: () => navigate(context, const InputNilaiScreen()),
          ),

          ListTile(
            leading: const Icon(Icons.analytics),
            title: const Text("Hasil Rekomendasi"),
            onTap: () => navigate(context, const HasilScreen()),
          ),

          ListTile(
            leading: const Icon(Icons.history),
            title: const Text("Riwayat"),
            onTap: () => navigate(context, const RiwayatScreen()),
          ),

          ListTile(
            leading: const Icon(Icons.message),
            title: const Text("Pesan Dosen"),
            onTap: () => navigate(context, const PesanDosenScreen()),
          ),

          const Spacer(),
          const Divider(),

          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Logout"),
            onTap: () {
              ApiService.token = null;

              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          ),
        ],
      ),
    );
  }
}
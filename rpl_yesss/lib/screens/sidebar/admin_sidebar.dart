import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../auth/login_screen.dart';
import '../admin/admin_dashboard_screen.dart';
import '../admin/data_training_screen.dart';
import '../admin/kelola_user_screen.dart';
import '../admin/set_k_screen.dart';
import '../admin/statistic_screen.dart';

class AdminSidebar extends StatelessWidget {
  const AdminSidebar({super.key});

  void navigate(BuildContext context, Widget page) {
    Navigator.pop(context); // tutup drawer
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
            accountName: Text("Admin"),
            accountEmail: Text("admin@gmail.com"),
            currentAccountPicture: CircleAvatar(
              child: Icon(Icons.admin_panel_settings),
            ),
          ),

          ListTile(
            leading: const Icon(Icons.dashboard),
            title: const Text("Dashboard"),
            onTap: () => navigate(context, const AdminDashboard()),
          ),

          ListTile(
            leading: const Icon(Icons.storage),
            title: const Text("Data Training"),
            onTap: () => navigate(context, const DataTrainingScreen()),
          ),

          ListTile(
            leading: const Icon(Icons.people),
            title: const Text("Kelola User"),
            onTap: () => navigate(context, const KelolaUserScreen()),
          ),

          ListTile(
            leading: const Icon(Icons.settings),
            title: const Text("Set Nilai K"),
            onTap: () => navigate(context, const SetKScreen()),
          ),

          ListTile(
            leading: const Icon(Icons.bar_chart),
            title: const Text("Statistik"),
            onTap: () => navigate(context, const StatisticScreen()),
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
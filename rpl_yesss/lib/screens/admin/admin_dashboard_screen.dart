import 'package:flutter/material.dart';

// IMPORT SCREEN
import 'data_training_screen.dart';
import 'kelola_user_screen.dart';
import 'set_k_screen.dart';
import 'statistic_screen.dart';

class AdminDashboard extends StatelessWidget {
  const AdminDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Admin"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              // 🔥 balik ke login + clear stack
              Navigator.pushNamedAndRemoveUntil(
                context,
                '/',
                (route) => false,
              );
            },
          )
        ],
      ),

      body: Padding(
        padding: const EdgeInsets.all(16),
        child: GridView.count(
          crossAxisCount: 2,
          crossAxisSpacing: 12,
          mainAxisSpacing: 12,
          children: [

            // 🔥 DATA TRAINING
            _menuBox(
              context,
              title: "Data Training",
              icon: Icons.storage,
              color: Colors.blue,
              screen: const DataTrainingScreen(),
            ),

            // 🔥 KELOLA USER
            _menuBox(
              context,
              title: "Kelola User",
              icon: Icons.people,
              color: Colors.red,
              screen: const KelolaUserScreen(),
            ),

            // 🔥 SET K
            _menuBox(
              context,
              title: "Set Nilai K",
              icon: Icons.settings,
              color: Colors.purple,
              screen: const SetKScreen(),
            ),

            // 🔥 STATISTIK
            _menuBox(
              context,
              title: "Statistik",
              icon: Icons.bar_chart,
              color: Colors.green,
              screen: const StatisticScreen(),
            ),
          ],
        ),
      ),
    );
  }

  // 🔥 REUSABLE MENU BOX
  Widget _menuBox(
    BuildContext context, {
    required String title,
    required IconData icon,
    required Color color,
    required Widget screen,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(16),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (_) => screen),
        );
      },
      child: Container(
        decoration: BoxDecoration(
          color: color,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black26,
              blurRadius: 5,
              offset: Offset(2, 3),
            )
          ],
        ),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(icon, size: 40, color: Colors.white),
            const SizedBox(height: 10),
            Text(
              title,
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            )
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../core/providers/theme_provider.dart';
import '../sidebar/user_sidebar.dart';
import 'input_nilai_screen.dart';
import 'hasil_screen.dart';

class UserDashboard extends StatelessWidget {
  final String? username;

  const UserDashboard({super.key, this.username});

  static const _monthNames = [
    'Jan',
    'Feb',
    'Mar',
    'Apr',
    'Mei',
    'Jun',
    'Jul',
    'Agu',
    'Sep',
    'Okt',
    'Nov',
    'Des',
  ];

  String _formattedDate(DateTime now) {
    final month = _monthNames[now.month - 1];
    return '$month ${now.day}, ${now.year}';
  }

  String _formattedTime(DateTime now) {
    final hour = now.hour % 12 == 0 ? 12 : now.hour % 12;
    final minute = now.minute.toString().padLeft(2, '0');
    final period = now.hour < 12 ? 'AM' : 'PM';
    return '$hour:$minute $period';
  }

  String get _displayName {
    final name = username?.trim().isNotEmpty == true
        ? username!.trim()
        : ApiService.currentUsername?.trim().isNotEmpty == true
            ? ApiService.currentUsername!.trim()
            : 'Mahasiswa';
    return name;
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final now = DateTime.now();
    final scaffoldKey = GlobalKey<ScaffoldState>();

    return Scaffold(
      key: scaffoldKey,
      drawer: const UserSidebar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  IconButton(
                    onPressed: () => scaffoldKey.currentState?.openDrawer(),
                    icon: const Icon(Icons.menu, size: 28),
                  ),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
                        onPressed: () =>
                            Provider.of<ThemeProvider>(context, listen: false)
                                .toggleTheme(),
                      ),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.end,
                        children: [
                          Text(
                            _formattedDate(now),
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 2),
                          Text(
                            _formattedTime(now),
                            style: const TextStyle(
                              color: Colors.black54,
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  const Text(
                    'Dashboard',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Container(
                    padding:
                        const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFFE8ECFF),
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Row(
                      children: [
                        CircleAvatar(
                          radius: 16,
                          backgroundColor: const Color(0xFF2D60FF),
                          child: Text(
                            _displayName
                                .split(' ')
                                .where((part) => part.isNotEmpty)
                                .map((part) => part[0])
                                .take(2)
                                .join()
                                .toUpperCase(),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                        const SizedBox(width: 8),
                        Text(
                          _displayName,
                          style: const TextStyle(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  )
                ],
              ),
              const SizedBox(height: 24),
              Container(
                width: double.infinity,
                decoration: BoxDecoration(
                  color: const Color(0xFF5F8CFF),
                  borderRadius: BorderRadius.circular(24),
                ),
                padding: const EdgeInsets.all(20),
                child: Row(
                  children: [
                    Container(
                      width: 88,
                      height: 88,
                      decoration: BoxDecoration(
                        color: const Color(0xFFB6C8FF),
                        shape: BoxShape.circle,
                      ),
                      child: const Center(
                        child: Icon(
                          Icons.person,
                          color: Colors.white,
                          size: 44,
                        ),
                      ),
                    ),
                    const SizedBox(width: 18),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Selamat Datang!',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            _displayName,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 5),
                          const Text(
                            'NIM:250512....',
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                        ],
                      ),
                    )
                  ],
                ),
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: const Color(0xFFF8F0B5),
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: const [
                          Text(
                            'Status Rekomendasi',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          SizedBox(height: 16),
                          Chip(
                            label: Text(
                              'Belum ada Hasil',
                              style: TextStyle(
                                color: Color(0xFFB67A08),
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            backgroundColor: Color(0xFFF2E19F),
                          ),
                          SizedBox(height: 12),
                          Text(
                            'Silahkan input data untuk mendapatkan rekomendasi bidang minat',
                            style: TextStyle(
                              color: Colors.black54,
                              height: 1.5,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(16),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.black.withOpacity(0.05),
                            blurRadius: 10,
                            offset: Offset(0, 4),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            'Aksi Cepat',
                            style: TextStyle(
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          const SizedBox(height: 24),
                          SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: () {
                                Navigator.pushReplacement(
                                  context,
                                  MaterialPageRoute(
                                    builder: (_) => const InputNilaiScreen(),
                                  ),
                                );
                              },
                              style: ElevatedButton.styleFrom(
                                padding:
                                    const EdgeInsets.symmetric(vertical: 14),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(14),
                                ),
                                backgroundColor: const Color(0xFF2D60FF),
                              ),
                              child: const Text(
                                'Mulai Input Data',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
            ],
          ),
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

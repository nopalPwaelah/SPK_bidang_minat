import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

// IMPORT SCREEN
import 'data_training_screen.dart';
import 'kelola_user_screen.dart';
import 'set_k_screen.dart';
import 'statistic_screen.dart';
import '../sidebar/admin_sidebar.dart';
import '../../services/api_service.dart';
import '../../core/providers/theme_provider.dart';
import '../auth/login_screen.dart';

class AdminDashboard extends StatefulWidget {
  const AdminDashboard({super.key});

  @override
  State<AdminDashboard> createState() => _AdminDashboardState();
}

class _AdminDashboardState extends State<AdminDashboard> {
  List<dynamic> mahasiswaBaru = [];
  bool isLoading = true;

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

  @override
  void initState() {
    super.initState();
    fetchMahasiswaBaru();
  }

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

  void fetchMahasiswaBaru() async {
    setState(() {
      isLoading = true;
    });

    try {
      final res = await ApiService.getUsers();
      setState(() {
        mahasiswaBaru = res.where((u) => u["role"] == "mahasiswa").toList();
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: $e")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final now = DateTime.now();

    return Scaffold(
      appBar: AppBar(
        title: const Text("Dashboard Admin"),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () =>
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme(),
          ),
          IconButton(
            icon: const Icon(Icons.logout),
            onPressed: () {
              ApiService.token = null;
              Navigator.pushAndRemoveUntil(
                context,
                MaterialPageRoute(builder: (_) => const LoginScreen()),
                (route) => false,
              );
            },
          )
        ],
      ),
      drawer: const AdminSidebar(),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Greeting Card (Image 1 Style)
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
                        Icons.admin_panel_settings,
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
                          ApiService.currentUsername ?? 'Administrator',
                          style: const TextStyle(
                            color: Colors.white,
                            fontSize: 22,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 5),
                        Text(
                          'Role: Admin',
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
            const SizedBox(height: 32),

            // Tabel Mahasiswa Baru (Image 2 Style)
            const Text(
              'mahasiswa baru',
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w600,
              ),
            ),
            const SizedBox(height: 16),

            isLoading
                ? const Center(child: CircularProgressIndicator())
                : mahasiswaBaru.isEmpty
                    ? const Center(child: Text("Tidak ada mahasiswa baru"))
                    : SingleChildScrollView(
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                          headingRowColor: MaterialStateColor.resolveWith(
                            (_) => const Color(0xFFF5F5F5),
                          ),
                          columns: const [
                            DataColumn(
                              label: Text(
                                'NO',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'NAME',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'EMAIL',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'ROLE',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                            DataColumn(
                              label: Text(
                                'ACTIONS',
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                            ),
                          ],
                          rows: List<DataRow>.generate(
                            mahasiswaBaru.length,
                            (index) {
                              final student = mahasiswaBaru[index];
                              return DataRow(
                                cells: [
                                  DataCell(
                                    Text('${index + 1}'),
                                  ),
                                  DataCell(
                                    Text(student['username'] ?? '-'),
                                  ),
                                  DataCell(
                                    Text(student['email'] ?? '-'),
                                  ),
                                  DataCell(
                                    Text(student['role'] ?? '-'),
                                  ),
                                  DataCell(
                                    Row(
                                      children: [
                                        IconButton(
                                          icon: const Icon(
                                            Icons.edit,
                                            size: 18,
                                            color: Colors.blue,
                                          ),
                                          onPressed: () {},
                                        ),
                                        IconButton(
                                          icon: const Icon(
                                            Icons.delete,
                                            size: 18,
                                            color: Colors.red,
                                          ),
                                          onPressed: () {},
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              );
                            },
                          ),
                        ),
                      ),
          ],
        ),
      ),
    );
  }
}
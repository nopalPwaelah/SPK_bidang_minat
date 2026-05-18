import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../core/providers/theme_provider.dart';
import '../sidebar/user_sidebar.dart';
import 'hasil_screen.dart';

class InputNilaiScreen extends StatefulWidget {
  const InputNilaiScreen({super.key});

  @override
  State<InputNilaiScreen> createState() => _InputNilaiScreenState();
}

class _InputNilaiScreenState extends State<InputNilaiScreen> {
  final namaController = TextEditingController();
  final matematikaController = TextEditingController();
  final pemrogramanController = TextEditingController();
  final basisDataController = TextEditingController();
  final jaringanController = TextEditingController();
  final aiController = TextEditingController();
  final strukturDataController = TextEditingController();
  final statistikaController = TextEditingController();
  final osController = TextEditingController();
  final pboController = TextEditingController();

  bool isLoading = false;

  void submit() async {
    setState(() {
      isLoading = true;
    });

    try {
      final res = await ApiService.submitNilai({
        "nama": namaController.text,
        "matematika": double.parse(matematikaController.text),
        "pemrograman_dasar": double.parse(pemrogramanController.text),
        "basis_data": double.parse(basisDataController.text),
        "jaringan_komputer": double.parse(jaringanController.text),
        "kecerdasan_buatan": double.parse(aiController.text),
        "struktur_data": double.parse(strukturDataController.text),
        "statistika": double.parse(statistikaController.text),
        "sistem_operasi": double.parse(osController.text),
        "pbo": double.parse(pboController.text),
      });

      setState(() {
        isLoading = false;
      });

      if (mounted) {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (_) => HasilScreen(data: res),
          ),
        );
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text("Error: $e"),
        ),
      );
    }
  }

  Widget inputField(String label, TextEditingController c) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 12),
      child: TextField(
        controller: c,
        keyboardType: TextInputType.number,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: const Color(0xFFF8FAFF),
          contentPadding: const EdgeInsets.symmetric(
            vertical: 16,
            horizontal: 18,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
        ),
      ),
    );
  }

  Widget fieldPair(
    String label1,
    TextEditingController controller1,
    String label2,
    TextEditingController controller2,
  ) {
    return Row(
      children: [
        Expanded(child: inputField(label1, controller1)),
        const SizedBox(width: 12),
        Expanded(child: inputField(label2, controller2)),
      ],
    );
  }

  void saveData() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Data nilai berhasil disimpan.'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          'Input Nilai Mahasiswa',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
        actions: [
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () =>
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme(),
          ),
        ],
      ),
      drawer: const UserSidebar(),
      body: Stack(
        children: [
          ClipPath(
            clipper: _HeaderClipper(),
            child: Container(
              height: 280,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF3B82F6), Color(0xFF2563EB)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              children: [
                const SizedBox(height: 100),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.08),
                        blurRadius: 18,
                        offset: const Offset(0, 10),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Selamat Datang!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 10),
                      Row(
                        children: [
                          Container(
                            width: 60,
                            height: 60,
                            decoration: BoxDecoration(
                              color: const Color(0xFFE0E7FF),
                              shape: BoxShape.circle,
                            ),
                            child: const Icon(
                              Icons.person,
                              color: Color(0xFF2563EB),
                              size: 32,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  namaController.text.isEmpty
                                      ? 'Naufal Akbar Putra'
                                      : namaController.text,
                                  style: const TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                                const SizedBox(height: 4),
                                const Text(
                                  'NIM: 25051204322',
                                  style: TextStyle(
                                    fontSize: 14,
                                    color: Colors.black54,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(18),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(24),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.06),
                        blurRadius: 16,
                        offset: const Offset(0, 8),
                      ),
                    ],
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'Input Nilai Mahasiswa',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 16),
                      TextField(
                        controller: namaController,
                        decoration: InputDecoration(
                          labelText: 'Nama Mahasiswa',
                          filled: true,
                          fillColor: const Color(0xFFF8FAFF),
                          contentPadding: const EdgeInsets.symmetric(
                            vertical: 16,
                            horizontal: 18,
                          ),
                          border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(16),
                            borderSide: BorderSide.none,
                          ),
                        ),
                      ),
                      const SizedBox(height: 16),
                      fieldPair('Matematika', matematikaController,
                          'Pemrograman Dasar', pemrogramanController),
                      fieldPair('Basis Data', basisDataController,
                          'Jaringan Komputer', jaringanController),
                      fieldPair('Kecerdasan Buatan', aiController,
                          'Struktur Data', strukturDataController),
                      fieldPair('Statistika', statistikaController,
                          'Sistem Operasi', osController),
                      inputField('PBO', pboController),
                      const SizedBox(height: 22),
                      Row(
                        children: [
                          Expanded(
                            child: OutlinedButton(
                              onPressed: saveData,
                              style: OutlinedButton.styleFrom(
                                foregroundColor: const Color(0xFF2563EB),
                                side:
                                    const BorderSide(color: Color(0xFF2563EB)),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: const Text('SAVE'),
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: ElevatedButton(
                              onPressed: isLoading ? null : submit,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFF2563EB),
                                padding:
                                    const EdgeInsets.symmetric(vertical: 16),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(16),
                                ),
                              ),
                              child: isLoading
                                  ? const SizedBox(
                                      height: 20,
                                      width: 20,
                                      child: CircularProgressIndicator(
                                        color: Colors.white,
                                        strokeWidth: 2.2,
                                      ),
                                    )
                                  : const Text('ANALYZE'),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    namaController.dispose();
    matematikaController.dispose();
    pemrogramanController.dispose();
    basisDataController.dispose();
    jaringanController.dispose();
    aiController.dispose();
    strukturDataController.dispose();
    statistikaController.dispose();
    osController.dispose();
    pboController.dispose();
    super.dispose();
  }
}

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 60);
    path.quadraticBezierTo(
      size.width * 0.25,
      size.height,
      size.width * 0.5,
      size.height - 40,
    );
    path.quadraticBezierTo(
      size.width * 0.75,
      size.height - 80,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) {
    return false;
  }
}

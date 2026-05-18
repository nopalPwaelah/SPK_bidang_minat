import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../core/providers/theme_provider.dart';
import '../sidebar/user_sidebar.dart';

class HasilScreen extends StatefulWidget {
  final Map? data;

  const HasilScreen({super.key, this.data});

  @override
  State<HasilScreen> createState() => _HasilScreenState();
}

class _HasilScreenState extends State<HasilScreen> {
  bool isSaved = false;

  void saveResult() {
    setState(() => isSaved = true);
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text("Hasil tersimpan di riwayat"),
        duration: Duration(seconds: 2),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;
    final hasilPrediksi = widget.data?['hasil_prediksi'] ?? widget.data?['hasil'] ?? "-";
    final nama = widget.data?['nama'] ?? "-";
    final nilaiK = widget.data?['nilai_k'] ?? 3;

    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.white),
        title: const Text(
          "Hasil Rekomendasi",
          style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
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
          // Header Background
          ClipPath(
            clipper: _HeaderClipper(),
            child: Container(
              height: 280,
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  colors: [Color(0xFF10B981), Color(0xFF059669)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
              ),
            ),
          ),
          // Content
          SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 60),
                // Main Result Card
                Card(
                  elevation: 8,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(16),
                      gradient: const LinearGradient(
                        colors: [Color(0xFF10B981), Color(0xFF059669)],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Text(
                            "Bidang Minat Rekomendasi",
                            style: TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          const SizedBox(height: 12),
                          Text(
                            hasilPrediksi,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 32,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                // Detail Information
                Text(
                  "Detail Prediksi",
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                ),
                const SizedBox(height: 12),
                // Nama
                _buildDetailCard(
                  context: context,
                  icon: Icons.person,
                  label: "Nama",
                  value: nama,
                ),
                const SizedBox(height: 10),
                // K Value
                _buildDetailCard(
                  context: context,
                  icon: Icons.settings,
                  label: "Nilai K (KNN)",
                  value: nilaiK.toString(),
                ),
                const SizedBox(height: 24),
                // Nilai Input (jika ada)
                if (widget.data?.containsKey('matematika') ?? false)
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Detail Nilai Input",
                        style: Theme.of(context).textTheme.titleMedium?.copyWith(
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      const SizedBox(height: 12),
                      _buildValueGrid(widget.data!),
                      const SizedBox(height: 24),
                    ],
                  ),
                // Buttons
                Row(
                  children: [
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: const Icon(Icons.arrow_back),
                        label: const Text("Kembali"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFF6366F1),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                    const SizedBox(width: 12),
                    Expanded(
                      child: ElevatedButton.icon(
                        onPressed: isSaved ? null : saveResult,
                        icon: Icon(isSaved ? Icons.check : Icons.save),
                        label: Text(isSaved ? "Tersimpan" : "Simpan"),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: isSaved ? Colors.grey : const Color(0xFF10B981),
                          foregroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 12),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailCard({
    required BuildContext context,
    required IconData icon,
    required String label,
    required String value,
  }) {
    final textTheme = Theme.of(context).textTheme;

    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: const Color(0xFF10B981).withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Icon(icon, color: const Color(0xFF10B981), size: 24),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    label,
                    style: textTheme.bodySmall?.copyWith(
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    value,
                    style: textTheme.bodyLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildValueGrid(Map data) {
    final nilai = {
      'Matematika': data['matematika'],
      'Pemrograman': data['pemrograman_dasar'],
      'Basis Data': data['basis_data'],
      'Jaringan': data['jaringan_komputer'],
      'AI': data['kecerdasan_buatan'],
      'Struktur Data': data['struktur_data'],
    };

    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      childAspectRatio: 2,
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      children: nilai.entries.map((entry) {
        return Card(
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              gradient: LinearGradient(
                colors: [
                  const Color(0xFF3B82F6).withOpacity(0.1),
                  const Color(0xFF2563EB).withOpacity(0.1),
                ],
              ),
            ),
            child: Padding(
              padding: const EdgeInsets.all(12),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    entry.key,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: Colors.black54,
                    ),
                    textAlign: TextAlign.center,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    entry.value?.toString() ?? "-",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.bold,
                      color: Color(0xFF3B82F6),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      }).toList(),
    );
  }
}

class _HeaderClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    final path = Path();
    path.lineTo(0, size.height - 40);
    path.quadraticBezierTo(
      size.width / 2,
      size.height,
      size.width,
      size.height - 40,
    );
    path.lineTo(size.width, 0);
    path.close();
    return path;
  }

  @override
  bool shouldReclip(CustomClipper<Path> oldClipper) => false;
}
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../core/providers/theme_provider.dart';
import '../sidebar/user_sidebar.dart';

class RiwayatScreen extends StatefulWidget {
  const RiwayatScreen({super.key});

  @override
  State<RiwayatScreen> createState() => _RiwayatScreenState();
}

class _RiwayatScreenState extends State<RiwayatScreen> {
  List data = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetch();
  }

  void fetch() async {
    try {
      final res = await ApiService.getPredictionHistory();
      setState(() {
        data = res;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  Color _getColorForResult(String? hasil) {
    switch (hasil?.toLowerCase()) {
      case 'rpl':
      case 'rekayasa perangkat lunak':
        return const Color(0xFF10B981);
      case 'ai':
      case 'ai engineering':
        return const Color(0xFF3B82F6);
      case 'cybersecurity':
      case 'cyber security':
        return const Color(0xFFEF4444);
      default:
        return const Color(0xFF6B7280);
    }
  }

  IconData _getIconForResult(String? hasil) {
    switch (hasil?.toLowerCase()) {
      case 'rpl':
      case 'rekayasa perangkat lunak':
        return Icons.code;
      case 'ai':
      case 'ai engineering':
        return Icons.psychology;
      case 'cybersecurity':
      case 'cyber security':
        return Icons.security;
      default:
        return Icons.info;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Riwayat Rekomendasi"),
        actions: [
          IconButton(
            onPressed: fetch,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () =>
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme(),
          ),
        ],
      ),
      drawer: const UserSidebar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : data.isEmpty
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.history, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        "Belum ada riwayat",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        "Mulai buat rekomendasi baru",
                        style: Theme.of(context).textTheme.bodySmall,
                      ),
                    ],
                  ),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16),
                  itemCount: data.length,
                  itemBuilder: (context, i) {
                    final item = data[i];
                    final hasil = item["hasil"] ?? item["hasil_prediksi"] ?? "-";
                    final tanggal = item["tanggal"] ?? item["created_at"] ?? "-";
                    final nilaiK = item["nilai_k"] ?? 3;
                    final skor = item["skor"] ?? 0.0;

                    return Card(
                      elevation: 4,
                      margin: const EdgeInsets.only(bottom: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {},
                        child: Container(
                          padding: const EdgeInsets.all(16),
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(12),
                            gradient: LinearGradient(
                              colors: [
                                _getColorForResult(hasil).withOpacity(0.1),
                                _getColorForResult(hasil).withOpacity(0.05),
                              ],
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                            ),
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                children: [
                                  Container(
                                    padding: const EdgeInsets.all(12),
                                    decoration: BoxDecoration(
                                      color: _getColorForResult(hasil),
                                      borderRadius: BorderRadius.circular(8),
                                    ),
                                    child: Icon(
                                      _getIconForResult(hasil),
                                      color: Colors.white,
                                    ),
                                  ),
                                  const SizedBox(width: 16),
                                  Expanded(
                                    child: Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          "Bidang Minat",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodySmall,
                                        ),
                                        const SizedBox(height: 4),
                                        Text(
                                          hasil,
                                          style: Theme.of(context)
                                              .textTheme
                                              .titleMedium,
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  Column(
                                    children: [
                                      Text(
                                        "K Neighbors",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        nilaiK.toString(),
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        "Skor",
                                        style: Theme.of(context)
                                            .textTheme
                                            .bodySmall,
                                      ),
                                      const SizedBox(height: 4),
                                      Text(
                                        "${(skor * 100).toStringAsFixed(1)}%",
                                        style: Theme.of(context)
                                            .textTheme
                                            .titleSmall,
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                              const SizedBox(height: 16),
                              Container(
                                width: double.infinity,
                                padding:
                                    const EdgeInsets.symmetric(vertical: 8),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                  borderRadius: BorderRadius.circular(8),
                                ),
                                child: Center(
                                  child: Text(
                                    "Tanggal: $tanggal",
                                    style: Theme.of(context)
                                        .textTheme
                                        .bodySmall,
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
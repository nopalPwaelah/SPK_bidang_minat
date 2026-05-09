import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../sidebar/admin_sidebar.dart';

class StatisticScreen extends StatefulWidget {
  const StatisticScreen({super.key});

  @override
  State<StatisticScreen> createState() => _StatisticScreenState();
}

class _StatisticScreenState extends State<StatisticScreen> {
  bool isLoading = true;

  int total = 0;
  int rpl = 0;
  int jaringan = 0;
  int iot = 0;
  int kValue = 3;

  Map<int, Map<String, int>> yearlyStats = {};

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // 🔥 LOAD DATA DARI API
  void loadData() async {
    try {
      final stats = await ApiService.getStatistics();
      final yearly = await ApiService.getYearlyStatistics();
      final k = await ApiService.getK();

      setState(() {
        total = stats["total"] ?? 0;
        rpl = stats["RPL"] ?? 0;
        jaringan = stats["Jaringan"] ?? 0;
        iot = stats["IoT"] ?? 0;
        kValue = k["k"] ?? 3;

        // Convert yearly stats
        (yearly as Map).forEach((key, value) {
          int year = int.tryParse(key.toString()) ?? 2022;
          yearlyStats[year] = {
            "RPL": (value["RPL"] as num?)?.toInt() ?? 0,
            "Jaringan": (value["Jaringan"] as num?)?.toInt() ?? 0,
            "IoT": (value["IoT"] as num?)?.toInt() ?? 0,
          };
        });

        isLoading = false;
      });
    } catch (e) {
      print("Error loading statistics: $e");
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistik"),
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadData,
          )
        ],
      ),
      drawer: const AdminSidebar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ===== TOTAL DATA TRAINING =====
                    _buildTotalCard(),
                    const SizedBox(height: 24),

                    // ===== BIDANG MINAT CARDS =====
                    _buildBidangMinatCards(),
                    const SizedBox(height: 24),

                    // ===== NILAI K AKTIF =====
                    _buildKAktifCard(),
                    const SizedBox(height: 24),

                    // ===== YEARLY TRENDS CHART =====
                    _buildYearlyTrendsChart(),
                    const SizedBox(height: 24),

                    // ===== YEARLY PROGRESS BARS =====
                    _buildYearlyProgressBars(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
    );
  }

  // ===== TOTAL CARD =====
  Widget _buildTotalCard() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.blue,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              const Text(
                "Total Data Training",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 12),
              Text(
                total.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===== BIDANG MINAT CARDS =====
  Widget _buildBidangMinatCards() {
    return GridView.count(
      crossAxisCount: 3,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      crossAxisSpacing: 12,
      mainAxisSpacing: 12,
      children: [
        _buildBidangCard("RPL", rpl.toString(), Colors.green),
        _buildBidangCard("Jaringan", jaringan.toString(), Colors.orange),
        _buildBidangCard("IoT", iot.toString(), Colors.purple),
      ],
    );
  }

  // ===== BIDANG CARD =====
  Widget _buildBidangCard(String title, String count, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            title,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 12,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            count,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  // ===== NILAI K AKTIF CARD =====
  Widget _buildKAktifCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.red,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Column(
            children: [
              const Text(
                "Nilai K Aktif",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
              ),
              const SizedBox(height: 8),
              Text(
                kValue.toString(),
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // ===== YEARLY TRENDS CHART (MANUAL BAR CHART) =====
  Widget _buildYearlyTrendsChart() {
    List<int> years = [2022, 2023, 2024, 2025];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Yearly Trends",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 200,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: years.map((year) {
                int rplCount = yearlyStats[year]?["RPL"] ?? 0;
                int jaringanCount = yearlyStats[year]?["Jaringan"] ?? 0;
                int iotCount = yearlyStats[year]?["IoT"] ?? 0;

                int maxHeight = [rplCount, jaringanCount, iotCount]
                    .reduce((a, b) => a > b ? a : b)
                    .clamp(1, 100);

                if (maxHeight == 0) maxHeight = 1;

                return Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    // RPL Bar (Blue)
                    Container(
                      width: 25,
                      height: (rplCount / maxHeight * 160).toDouble(),
                      color: Colors.blue,
                      margin: const EdgeInsets.only(bottom: 4),
                    ),
                    // Jaringan Bar (Orange)
                    Container(
                      width: 25,
                      height: (jaringanCount / maxHeight * 160).toDouble(),
                      color: Colors.orange,
                      margin: const EdgeInsets.only(bottom: 4),
                    ),
                    // IoT Bar (Grey)
                    Container(
                      width: 25,
                      height: (iotCount / maxHeight * 160).toDouble(),
                      color: Colors.grey,
                    ),
                  ],
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 16),
          // Legend
          Row(
            children: [
              _buildLegendItem("IoT", Colors.blue),
              const SizedBox(width: 16),
              _buildLegendItem("RPL", Colors.orange),
              const SizedBox(width: 16),
              _buildLegendItem("JARINGAN Komputer", Colors.grey),
            ],
          ),
          const SizedBox(height: 8),
          // Year labels
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: years.map((year) {
              return Text(
                year.toString(),
                style: const TextStyle(fontSize: 12),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }

  // ===== LEGEND ITEM =====
  Widget _buildLegendItem(String label, Color color) {
    return Row(
      children: [
        Container(
          width: 12,
          height: 12,
          color: color,
        ),
        const SizedBox(width: 8),
        Text(
          label,
          style: const TextStyle(fontSize: 12),
        ),
      ],
    );
  }

  // ===== YEARLY PROGRESS BARS =====
  Widget _buildYearlyProgressBars() {
    List<int> years = [2022, 2023, 2024];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            "Yearly Trends",
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 16),
          ...years.map((year) {
            int rplCount = yearlyStats[year]?["RPL"] ?? 0;
            int jaringanCount = yearlyStats[year]?["Jaringan"] ?? 0;
            int iotCount = yearlyStats[year]?["IoT"] ?? 0;
            int totalYear = rplCount + jaringanCount + iotCount;

            // Calculate percentages
            double rplPercent = totalYear > 0 ? (rplCount / totalYear) : 0;
            double jaringanPercent =
                totalYear > 0 ? (jaringanCount / totalYear) : 0;

            return Container(
              margin: const EdgeInsets.only(bottom: 12),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                border: Border.all(color: Colors.grey.shade300),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    year.toString(),
                    style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(4),
                    child: Row(
                      children: [
                        // RPL portion (Purple)
                        Expanded(
                          flex: (rplPercent * 100).toInt(),
                          child: Container(
                            height: 8,
                            color: const Color(0xFF6B5B95),
                          ),
                        ),
                        // Jaringan portion (Light Purple)
                        Expanded(
                          flex: (jaringanPercent * 100).toInt(),
                          child: Container(
                            height: 8,
                            color: const Color(0xFFB8A8D8),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            );
          }).toList(),
        ],
      ),
    );
  }
}
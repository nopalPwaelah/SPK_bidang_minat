import 'package:flutter/material.dart';
import '../../services/api_service.dart';

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

  @override
  void initState() {
    super.initState();
    loadData();
  }

  // 🔥 LOAD DATA DARI API
  void loadData() async {
    try {
      final stats = await ApiService.getStatistics();
      final k = await ApiService.getK();

      setState(() {
        total = stats["total"];
        rpl = stats["RPL"];
        jaringan = stats["Jaringan"];
        iot = stats["IoT"];
        kValue = k["k"];
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  // UI CARD
  Widget statCard(String title, String value, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Text(title, style: const TextStyle(color: Colors.white)),
          const SizedBox(height: 10),
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Statistik"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: loadData,
          )
        ],
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  // 🔥 TOTAL
                  statCard("Total Data Training", total.toString(), Colors.blue),

                  const SizedBox(height: 16),

                  // 🔥 GRID BIDANG
                  GridView.count(
                    crossAxisCount: 3,
                    shrinkWrap: true,
                    crossAxisSpacing: 10,
                    mainAxisSpacing: 10,
                    children: [
                      statCard("RPL", rpl.toString(), Colors.green),
                      statCard("Jaringan", jaringan.toString(), Colors.orange),
                      statCard("IoT", iot.toString(), Colors.purple),
                    ],
                  ),

                  const SizedBox(height: 16),

                  // 🔥 NILAI K
                  statCard("Nilai K Aktif", kValue.toString(), Colors.red),
                ],
              ),
            ),
    );
  }
}
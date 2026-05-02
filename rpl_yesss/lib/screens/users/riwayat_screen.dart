import 'package:flutter/material.dart';
import '../../services/api_service.dart';

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
      final res = await ApiService.getStatistics(); // sementara reuse
      setState(() {
        data = res;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Riwayat Rekomendasi")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : ListView.builder(
              itemCount: data.length,
              itemBuilder: (context, i) {
                final item = data[i];
                return Card(
                  child: ListTile(
                    title: Text("Hasil: ${item["hasil"]}"),
                    subtitle: Text("Tanggal: ${item["tanggal"] ?? "-"}"),
                  ),
                );
              },
            ),
    );
  }
}
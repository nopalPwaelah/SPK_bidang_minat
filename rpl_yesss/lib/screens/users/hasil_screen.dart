import 'package:flutter/material.dart';

class HasilScreen extends StatelessWidget {
  final Map? data;

  const HasilScreen({super.key, this.data});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Hasil Rekomendasi")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                title: const Text("Hasil"),
                subtitle: Text(data?['hasil'] ?? "-"),
              ),
            ),
            const SizedBox(height: 10),

            Card(
              child: ListTile(
                title: const Text("Statistik"),
                subtitle: Text(data?['detail']?.toString() ?? "-"),
              ),
            ),

            const SizedBox(height: 20),

            ElevatedButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text("Kembali"),
            )
          ],
        ),
      ),
    );
  }
}
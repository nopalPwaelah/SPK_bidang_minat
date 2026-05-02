import 'package:flutter/material.dart';

class PesanDosenScreen extends StatefulWidget {
  const PesanDosenScreen({super.key});

  @override
  State<PesanDosenScreen> createState() => _PesanDosenScreenState();
}

class _PesanDosenScreenState extends State<PesanDosenScreen> {

  final pesan = TextEditingController();

  void save() {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text("Pesan tersimpan")),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Pesan Dosen")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: pesan,
              maxLines: 6,
              decoration: const InputDecoration(
                hintText: "Masukkan pesan...",
                border: OutlineInputBorder(),
              ),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: save,
              child: const Text("Simpan"),
            )
          ],
        ),
      ),
    );
  }
}
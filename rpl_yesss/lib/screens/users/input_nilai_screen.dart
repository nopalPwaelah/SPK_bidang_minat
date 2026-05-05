import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../sidebar/user_sidebar.dart';
import '../users/hasil_screen.dart';
import '../sidebar/user_sidebar.dart';


class InputNilaiScreen extends StatefulWidget {
  const InputNilaiScreen({super.key});

  @override
  State<InputNilaiScreen> createState() => _InputNilaiScreenState();
}

class _InputNilaiScreenState extends State<InputNilaiScreen> {
  final ipk = TextEditingController();
  final algoritma = TextEditingController();
  final basisData = TextEditingController();

  bool isLoading = false;

  void submit() async {
    setState(() => isLoading = true);

    try {
      final res = await ApiService.submitNilai({
        "ipk": double.parse(ipk.text),
        "algoritma": double.parse(algoritma.text),
        "basis_data": double.parse(basisData.text),
      });

      setState(() => isLoading = false);

      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (_) => HasilScreen(data: res),
        ),
      );
    } catch (e) {
      setState(() => isLoading = false);
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Gagal kirim nilai")),
      );
    }
  }

  Widget inputField(String label, TextEditingController c) {
    return TextField(
      controller: c,
      keyboardType: TextInputType.number,
      decoration: InputDecoration(
        labelText: label,
        border: OutlineInputBorder(),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Input Nilai Mahasiswa")),
      drawer: const UserSidebar(),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            inputField("IPK", ipk),
            const SizedBox(height: 10),
            inputField("Algoritma", algoritma),
            const SizedBox(height: 10),
            inputField("Basis Data", basisData),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: isLoading ? null : submit,
              child: isLoading
                  ? const CircularProgressIndicator()
                  : const Text("Proses KNN"),
            )
          ],
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../sidebar/admin_sidebar.dart';

class SetKScreen extends StatefulWidget {
  const SetKScreen({super.key});

  @override
  State<SetKScreen> createState() => _SetKScreenState();
}

class _SetKScreenState extends State<SetKScreen> {

  final kController = TextEditingController();
  bool isLoading = true;
  int currentK = 3;

  @override
  void initState() {
    super.initState();
    getK();
  }

  @override
  void dispose() {
    kController.dispose();
    super.dispose();
  }

  // 🔥 GET NILAI K DARI BACKEND
  void getK() async {
    try {
      final res = await ApiService.getK();
      setState(() {
        currentK = res["k"];
        kController.text = currentK.toString();
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  // 🔥 UPDATE NILAI K
  void updateK() async {
    if (kController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nilai K tidak boleh kosong")),
      );
      return;
    }

    int k = int.tryParse(kController.text) ?? 0;

    if (k <= 0) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nilai K harus lebih dari 0")),
      );
      return;
    }

    try {
      await ApiService.setK(k);

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Nilai K berhasil diupdate")),
      );

      setState(() {
        currentK = k;
      });

    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal update K")),
      );
    }
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Set Nilai K"),
      ),
      drawer: const AdminSidebar(),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : Padding(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [

                  // INFO
                  const Text(
                    "Nilai K digunakan dalam algoritma KNN untuk menentukan jumlah tetangga terdekat.",
                    style: TextStyle(fontSize: 14),
                  ),

                  const SizedBox(height: 20),

                  // CURRENT K
                  Card(
                    child: ListTile(
                      title: const Text("Nilai K Saat Ini"),
                      trailing: Text(
                        currentK.toString(),
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // INPUT K
                  TextField(
                    controller: kController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: "Ubah Nilai K",
                      border: OutlineInputBorder(),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // BUTTON
                  SizedBox(
                    width: double.infinity,
                    child: ElevatedButton(
                      onPressed: updateK,
                      child: const Text("Simpan"),
                    ),
                  )
                ],
              ),
            ),
    );
  }
}
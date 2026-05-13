import 'package:flutter/material.dart';

import '../../services/api_service.dart';

import '../sidebar/user_sidebar.dart';

import 'hasil_screen.dart';

class InputNilaiScreen
    extends StatefulWidget {

  const InputNilaiScreen({
    super.key
  });

  @override
  State<InputNilaiScreen>
  createState() =>
      _InputNilaiScreenState();
}

class _InputNilaiScreenState
    extends State<InputNilaiScreen> {

  // =====================================
  // CONTROLLER
  // =====================================

  final namaController =
      TextEditingController();

  final matematikaController =
      TextEditingController();

  final pemrogramanController =
      TextEditingController();

  final basisDataController =
      TextEditingController();

  final jaringanController =
      TextEditingController();

  final aiController =
      TextEditingController();

  final strukturDataController =
      TextEditingController();

  final statistikaController =
      TextEditingController();

  final osController =
      TextEditingController();

  final pboController =
      TextEditingController();

  bool isLoading = false;

  // =====================================
  // SUBMIT
  // =====================================

  void submit() async {

    setState(() {
      isLoading = true;
    });

    try {

      final res =
          await ApiService.submitNilai({

        "nama":
            namaController.text,

        "matematika":
            double.parse(
                matematikaController.text),

        "pemrograman_dasar":
            double.parse(
                pemrogramanController.text),

        "basis_data":
            double.parse(
                basisDataController.text),

        "jaringan_komputer":
            double.parse(
                jaringanController.text),

        "kecerdasan_buatan":
            double.parse(
                aiController.text),

        "struktur_data":
            double.parse(
                strukturDataController.text),

        "statistika":
            double.parse(
                statistikaController.text),

        "sistem_operasi":
            double.parse(
                osController.text),

        "pbo":
            double.parse(
                pboController.text),
      });

      setState(() {
        isLoading = false;
      });

      if (mounted) {

        Navigator.push(

          context,

          MaterialPageRoute(

            builder: (_) =>
                HasilScreen(
                    data: res),
          ),
        );
      }

    } catch (e) {

      setState(() {
        isLoading = false;
      });

      ScaffoldMessenger.of(
          context).showSnackBar(

        SnackBar(
          content:
              Text("Error: $e"),
        ),
      );
    }
  }

  // =====================================
  // INPUT FIELD
  // =====================================

  Widget inputField(

      String label,

      TextEditingController c

  ) {

    return Padding(

      padding:
          const EdgeInsets.only(
              bottom: 12),

      child: TextField(

        controller: c,

        keyboardType:
            TextInputType.number,

        decoration:
            InputDecoration(

          labelText: label,

          border:
              OutlineInputBorder(

            borderRadius:
                BorderRadius
                    .circular(10),
          ),
        ),
      ),
    );
  }

  // =====================================
  // UI
  // =====================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(

        title: const Text(
            "Input Nilai"),
      ),

      drawer:
          const UserSidebar(),

      body:
          SingleChildScrollView(

        padding:
            const EdgeInsets.all(16),

        child: Column(

          children: [

            // =====================
            // NAMA
            // =====================

            TextField(

              controller:
                  namaController,

              decoration:
                  InputDecoration(

                labelText:
                    "Nama Mahasiswa",

                border:
                    OutlineInputBorder(

                  borderRadius:
                      BorderRadius
                          .circular(10),
                ),
              ),
            ),

            const SizedBox(
                height: 16),

            // =====================
            // NILAI
            // =====================

            inputField(
                "Matematika",
                matematikaController),

            inputField(
                "Pemrograman Dasar",
                pemrogramanController),

            inputField(
                "Basis Data",
                basisDataController),

            inputField(
                "Jaringan Komputer",
                jaringanController),

            inputField(
                "Kecerdasan Buatan",
                aiController),

            inputField(
                "Struktur Data",
                strukturDataController),

            inputField(
                "Statistika",
                statistikaController),

            inputField(
                "Sistem Operasi",
                osController),

            inputField(
                "Pemrograman Berorientasi Objek",
                pboController),

            const SizedBox(
                height: 20),

            // =====================
            // BUTTON
            // =====================

            SizedBox(

              width: double.infinity,

              height: 50,

              child: ElevatedButton(

                onPressed:
                    isLoading
                        ? null
                        : submit,

                child: isLoading

                    ? const CircularProgressIndicator()

                    : const Text(
                        "Proses KNN"),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
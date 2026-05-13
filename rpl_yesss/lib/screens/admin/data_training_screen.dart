import 'package:flutter/material.dart';

import '../../services/api_service.dart';

import '../sidebar/admin_sidebar.dart';

class DataTrainingScreen
    extends StatefulWidget {

  const DataTrainingScreen({
    super.key
  });

  @override
  State<DataTrainingScreen>
  createState() =>
      _DataTrainingScreenState();
}

class _DataTrainingScreenState
    extends State<DataTrainingScreen> {

  List data = [];

  bool isLoading = true;

  bool isEditing = false;

  int? selectedId;

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

  String minatJurusan = "RPL";

  // =====================================
  // INIT
  // =====================================

  @override
  void initState() {

    super.initState();

    fetchData();
  }

  // =====================================
  // FETCH
  // =====================================

  void fetchData() async {

    setState(() {
      isLoading = true;
    });

    try {

      final res =
          await ApiService
              .getTrainingData();

      setState(() {

        data = res;

        isLoading = false;
      });

    } catch (e) {

      setState(() {
        isLoading = false;
      });
    }
  }

  // =====================================
  // RESET FORM
  // =====================================

  void resetForm() {

    isEditing = false;

    selectedId = null;

    namaController.clear();

    matematikaController.clear();

    pemrogramanController.clear();

    basisDataController.clear();

    jaringanController.clear();

    aiController.clear();

    strukturDataController.clear();

    statistikaController.clear();

    osController.clear();

    pboController.clear();

    minatJurusan = "RPL";
  }

  // =====================================
  // OPEN ADD
  // =====================================

  void openAddForm() {

    resetForm();

    showDialog(

      context: context,

      builder: (context) =>
          buildFormDialog(),
    );
  }

  // =====================================
  // OPEN EDIT
  // =====================================

  void openEditForm(
      Map item
  ) {

    isEditing = true;

    selectedId = item["id"];

    namaController.text =
        item["nama"].toString();

    matematikaController.text =
        item["matematika"].toString();

    pemrogramanController.text =
        item["pemrograman_dasar"]
            .toString();

    basisDataController.text =
        item["basis_data"]
            .toString();

    jaringanController.text =
        item["jaringan_komputer"]
            .toString();

    aiController.text =
        item["kecerdasan_buatan"]
            .toString();

    strukturDataController.text =
        item["struktur_data"]
            .toString();

    statistikaController.text =
        item["statistika"]
            .toString();

    osController.text =
        item["sistem_operasi"]
            .toString();

    pboController.text =
        item["pbo"].toString();

    minatJurusan =
        item["minat_jurusan"];

    showDialog(

      context: context,

      builder: (context) =>
          buildFormDialog(),
    );
  }

  // =====================================
  // SAVE DATA
  // =====================================

  Future<void> saveData()
  async {

    Map<String, dynamic>
    payload = {

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

      "minat_jurusan":
          minatJurusan,
    };

    try {

      if (isEditing) {

        await ApiService
            .updateTraining(
                selectedId!,
                payload);

      } else {

        await ApiService
            .addTraining(
                payload);
      }

      fetchData();

      if (mounted) {

        Navigator.pop(context);
      }

    } catch (e) {

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
  // DELETE
  // =====================================

  void deleteData(
      int id
  ) async {

    await ApiService
        .deleteTraining(id);

    fetchData();
  }

  // =====================================
  // FORM DIALOG
  // =====================================

  Widget buildFormDialog() {

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

    return AlertDialog(

      title: Text(

        isEditing
            ? "Edit Training"
            : "Tambah Training",
      ),

      content:
          SingleChildScrollView(

        child: Column(

          mainAxisSize:
              MainAxisSize.min,

          children: [

            TextField(

              controller:
                  namaController,

              decoration:
                  const InputDecoration(
                labelText: "Nama",
              ),
            ),

            const SizedBox(
                height: 16),

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
                "PBO",
                pboController),

            DropdownButtonFormField(

              value:
                  minatJurusan,

              items: [

                "RPL",

                "AI Engineering",

                "Cyber Security"

              ].map((e) {

                return DropdownMenuItem(

                  value: e,

                  child: Text(e),
                );

              }).toList(),

              onChanged: (v) {

                setState(() {

                  minatJurusan =
                      v!;
                });
              },
            ),
          ],
        ),
      ),

      actions: [

        ElevatedButton(

          onPressed: saveData,

          child: const Text(
              "Simpan"),
        ),
      ],
    );
  }

  // =====================================
  // UI
  // =====================================

  @override
  Widget build(BuildContext context) {

    return Scaffold(

      appBar: AppBar(
        title:
            const Text(
                "Data Training"),
      ),

      drawer:
          const AdminSidebar(),

      floatingActionButton:
          FloatingActionButton(

        onPressed: openAddForm,

        child:
            const Icon(Icons.add),
      ),

      body: isLoading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : ListView.builder(

              itemCount:
                  data.length,

              itemBuilder:
                  (context, index) {

                final item =
                    data[index];

                return Card(

                  margin:
                      const EdgeInsets
                          .all(10),

                  child: ListTile(

                    title: Text(
                        item["nama"]),

                    subtitle: Text(
                        item[
                            "minat_jurusan"]),

                    trailing: Row(

                      mainAxisSize:
                          MainAxisSize
                              .min,

                      children: [

                        IconButton(

                          icon: const Icon(
                              Icons.edit),

                          onPressed: () =>
                              openEditForm(
                                  item),
                        ),

                        IconButton(

                          icon: const Icon(
                              Icons.delete),

                          onPressed: () =>
                              deleteData(
                                  item["id"]),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}
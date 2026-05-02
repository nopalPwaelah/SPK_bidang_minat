import 'package:flutter/material.dart';
import '../../services/api_service.dart';

class DataTrainingScreen extends StatefulWidget {
  const DataTrainingScreen({super.key});

  @override
  State<DataTrainingScreen> createState() => _DataTrainingScreenState();
}

class _DataTrainingScreenState extends State<DataTrainingScreen> {

  List data = [];
  bool isLoading = true;

  // 🔥 FORM STATE
  bool isEditing = false;
  int? selectedId;

  final nama = TextEditingController();
  final tahun = TextEditingController();
  final ipk = TextEditingController();
  String bidang = "RPL";

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  void fetchData() async {
    setState(() => isLoading = true);

    final res = await ApiService.getTrainingData();

    setState(() {
      data = res;
      isLoading = false;
    });
  }

  // ================= ADD / EDIT =================
  void openAddForm() {
    setState(() {
      isEditing = false;
      selectedId = null;

      nama.clear();
      tahun.clear();
      ipk.clear();
      bidang = "RPL";
    });
  }

  void saveData() async {
  try {
    if (isEditing) {
      await ApiService.updateTraining(
        selectedId!,
        nama.text,
        double.parse(ipk.text),
        bidang,
      );
    } else {
      await ApiService.addTraining({
        "nama": nama.text,
        "ipk": double.parse(ipk.text),
        "bidang_minat": bidang,
      });
    }

    openAddForm();
    fetchData();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Gagal menyimpan data")),
    );
  }
}

void deleteData(int id) async {
  try {
    await ApiService.deleteTraining(id);
    fetchData();
  } catch (e) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text("Gagal hapus data")),
    );
  }
}
  Color getColor(String bidang) {
    switch (bidang) {
      case "RPL":
        return Colors.blue;
      case "Jaringan":
        return Colors.green;
      case "IoT":
        return Colors.purple;
      default:
        return Colors.grey;
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Training Data Management"),
        actions: [
          Padding(
            padding: const EdgeInsets.all(8),
            child: ElevatedButton.icon(
              onPressed: openAddForm,
              icon: const Icon(Icons.add),
              label: const Text("Add New Record"),
            ),
          )
        ],
      ),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [

                  // ================= FORM =================
                  Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [

                          Text(
                            isEditing ? "Edit Alumni Record" : "Add Alumni Record",
                            style: const TextStyle(
                                fontSize: 20, fontWeight: FontWeight.bold),
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              Expanded(
                                child: TextField(
                                  controller: nama,
                                  decoration:
                                      const InputDecoration(labelText: "Name"),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: tahun,
                                  decoration:
                                      const InputDecoration(labelText: "Year"),
                                ),
                              ),
                              const SizedBox(width: 10),
                              Expanded(
                                child: TextField(
                                  controller: ipk,
                                  decoration:
                                      const InputDecoration(labelText: "IPK"),
                                ),
                              ),
                            ],
                          ),

                          const SizedBox(height: 20),

                          DropdownButtonFormField<String>(
                            value: bidang,
                            decoration: const InputDecoration(
                              labelText: "Specialization",
                            ),
                            items: ["RPL", "Jaringan", "IoT"]
                                .map((e) => DropdownMenuItem(
                                      value: e,
                                      child: Text(e),
                                    ))
                                .toList(),
                            onChanged: (val) => bidang = val!,
                          ),

                          const SizedBox(height: 20),

                          Row(
                            children: [
                              ElevatedButton.icon(
                                onPressed: saveData,
                                icon: const Icon(Icons.save),
                                label: const Text("Save"),
                              ),
                              const SizedBox(width: 10),
                              OutlinedButton(
                                onPressed: openAddForm,
                                child: const Text("Cancel"),
                              ),
                            ],
                          )
                        ],
                      ),
                    ),
                  ),

                  const SizedBox(height: 20),

                  // ================= TABLE =================
                  Card(
                    elevation: 3,
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: DataTable(
                        columns: const [
                          DataColumn(label: Text("ID")),
                          DataColumn(label: Text("Name")),
                          DataColumn(label: Text("Year")),
                          DataColumn(label: Text("IPK")),
                          DataColumn(label: Text("Specialization")),
                          DataColumn(label: Text("Actions")),
                        ],
                        rows: data.map((item) {
                          return DataRow(cells: [
                            DataCell(Text("#${item["id"]}")),
                            DataCell(Text(item["nama"])),
                            DataCell(Text(item["tahun"]?.toString() ?? "-")),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: Colors.blue.shade100,
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(item["ipk"].toString()),
                              ),
                            ),
                            DataCell(
                              Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 4),
                                decoration: BoxDecoration(
                                  color: getColor(item["bidang_minat"])
                                      .withOpacity(0.2),
                                  borderRadius: BorderRadius.circular(20),
                                ),
                                child: Text(
                                  item["bidang_minat"],
                                  style: TextStyle(
                                      color:
                                          getColor(item["bidang_minat"])),
                                ),
                              ),
                            ),
                            DataCell(
                              Row(
                                
                              ),
                            ),
                          ]);
                        }).toList(),
                      ),
                    ),
                  ),
                ],
              ),
            ),
    );
  }
}
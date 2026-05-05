import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../sidebar/admin_sidebar.dart';

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

  @override
  void dispose() {
    nama.dispose();
    tahun.dispose();
    ipk.dispose();
    super.dispose();
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
  void resetForm() {
    setState(() {
      isEditing = false;
      selectedId = null;
      nama.clear();
      tahun.clear();
      ipk.clear();
      bidang = "RPL";
    });
  }

  void openAddForm() {
    resetForm();
    
    // Tampilkan dialog form
    showDialog(
      context: context,
      builder: (context) => _buildFormDialog(),
    );
  }

  void openEditForm(Map item) {
    setState(() {
      isEditing = true;
      selectedId = item["id"] as int?;
      nama.text = item["nama"]?.toString() ?? "";
      tahun.text = item["tahun"]?.toString() ?? "";
      ipk.text = item["ipk"]?.toString() ?? "";
      bidang = item["bidang_minat"]?.toString() ?? "RPL";
    });
    
    // Tampilkan dialog form
    showDialog(
      context: context,
      builder: (context) => _buildFormDialog(),
    );
  }

  Future<void> saveData() async {
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

      resetForm();
      fetchData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal menyimpan data")),
      );
    }
  }

  void deleteData(int id) async {
    try {
      await ApiService.deleteTraining(id);
      fetchData();
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Gagal hapus data")),
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

  // ================= BUILD FORM DIALOG =================
  Widget _buildFormDialog() {
    return Dialog(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      insetPadding: const EdgeInsets.all(16),
      child: Container(
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                isEditing ? "Edit Data Training" : "Tambah Data Training",
                style: const TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 24),
              
              // NAME FIELD
              TextField(
                controller: nama,
                decoration: InputDecoration(
                  labelText: "NAME",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 12,
                  ),
                ),
              ),
              const SizedBox(height: 16),
              
              // YEAR, IPK, SPESIALISASI in row
              Row(
                children: [
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: tahun,
                      decoration: InputDecoration(
                        labelText: "YEAR",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: TextField(
                      controller: ipk,
                      decoration: InputDecoration(
                        labelText: "IPK",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    flex: 2,
                    child: DropdownButtonFormField<String>(
                      value: bidang,
                      decoration: InputDecoration(
                        labelText: "SPESIALISASI",
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                          horizontal: 12,
                          vertical: 12,
                        ),
                      ),
                      items: ["RPL", "Jaringan", "IoT"]
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            bidang = val;
                          });
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              
              // BUTTONS
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  ElevatedButton(
                    onPressed: () async {
                      await saveData();
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C3E50),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      "SAVE",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                  const SizedBox(width: 12),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF2C3E50),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 32,
                        vertical: 12,
                      ),
                    ),
                    child: const Text(
                      "CANCEL",
                      style: TextStyle(color: Colors.white),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Data Training"),
        centerTitle: true,
        elevation: 0,
      ),

      drawer: const AdminSidebar(),

      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  // ================= TABLE HEADER =================
                  Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 16, vertical: 12),
                    decoration: BoxDecoration(
                      border: Border(
                        bottom: BorderSide(
                          color: Colors.grey.shade300,
                          width: 2,
                        ),
                      ),
                    ),
                    child: Row(
                      children: [
                        SizedBox(
                          width: 50,
                          child: Text("NO",
                              style: Theme.of(context).textTheme.labelLarge),
                        ),
                        Expanded(
                          flex: 3,
                          child: Text("NAME",
                              style: Theme.of(context).textTheme.labelLarge),
                        ),
                        SizedBox(
                          width: 100,
                          child: Text("YEAR",
                              style: Theme.of(context).textTheme.labelLarge),
                        ),
                        SizedBox(
                          width: 80,
                          child: Text("IPK",
                              style: Theme.of(context).textTheme.labelLarge),
                        ),
                        SizedBox(
                          width: 140,
                          child: Text("SPESIALISASI",
                              style: Theme.of(context).textTheme.labelLarge),
                        ),
                        SizedBox(
                          width: 120,
                          child: Text("ACTIONS",
                              style: Theme.of(context).textTheme.labelLarge),
                        ),
                      ],
                    ),
                  ),

                  // ================= TABLE ROWS =================
                  ...data.asMap().entries.map((entry) {
                    int index = entry.key;
                    Map item = entry.value;
                    return Column(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 16, vertical: 12),
                          decoration: BoxDecoration(
                            border: Border(
                              bottom: BorderSide(
                                color: Colors.grey.shade200,
                              ),
                            ),
                          ),
                          child: Row(
                            children: [
                              SizedBox(
                                width: 50,
                                child: Text("${index + 1}"),
                              ),
                              Expanded(
                                flex: 3,
                                child: Text(item["nama"] ?? "-"),
                              ),
                              SizedBox(
                                width: 100,
                                child: Text(item["tahun"]?.toString() ?? "-"),
                              ),
                              SizedBox(
                                width: 80,
                                child: Text(item["ipk"]?.toString() ?? "-"),
                              ),
                              SizedBox(
                                width: 140,
                                child: Text(item["bidang_minat"] ?? "-"),
                              ),
                              SizedBox(
                                width: 120,
                                child: Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    IconButton(
                                      icon: const Icon(Icons.check_box,
                                          color: Colors.grey, size: 20),
                                      tooltip: 'Edit',
                                      onPressed: () => openEditForm(item),
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.all(4),
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.delete_outline,
                                          color: Colors.grey, size: 20),
                                      tooltip: 'Delete',
                                      onPressed: () => deleteData(item["id"]),
                                      constraints: const BoxConstraints(),
                                      padding: const EdgeInsets.all(4),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    );
                  }).toList(),

                  // Pesan jika data kosong
                  if (data.isEmpty)
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 32),
                      child: Text(
                        "Tidak ada data training",
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ),
                ],
              ),
            ),

      // ================= FAB =================
      floatingActionButton: FloatingActionButton.extended(
        onPressed: openAddForm,
        backgroundColor: const Color(0xFF2C3E50),
        icon: const Icon(Icons.add),
        label: const Text("Tambah Data"),
      ),
    );
  }
}

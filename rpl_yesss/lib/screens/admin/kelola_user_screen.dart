import 'package:flutter/material.dart';
import '../../services/api_service.dart';
import '../sidebar/admin_sidebar.dart';

class KelolaUserScreen extends StatefulWidget {
  const KelolaUserScreen({super.key});

  @override
  State<KelolaUserScreen> createState() => _KelolaUserScreenState();
}

class _KelolaUserScreenState extends State<KelolaUserScreen> {
  List users = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  // 🔥 GET USERS
  void fetchUsers() async {
    setState(() => isLoading = true);

    try {
      final res = await ApiService.getUsers();
      setState(() {
        users = res;
        isLoading = false;
      });
    } catch (e) {
      setState(() => isLoading = false);
    }
  }

  // 🔥 DELETE USER
  void deleteUser(int id) async {
    await ApiService.deleteUser(id);
    fetchUsers();
  }

  // 🔥 ADD USER
  void showAddDialog() {
    final username = TextEditingController();
    final email = TextEditingController();
    final password = TextEditingController();
    String role = "mahasiswa";

    showDialog(
      context: context,
      builder: (_) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              title: const Text("Tambah User"),
              content: SingleChildScrollView(
                child: Column(
                  children: [
                    TextField(
                      controller: username,
                      decoration: const InputDecoration(labelText: "Username"),
                    ),
                    TextField(
                      controller: email,
                      decoration: const InputDecoration(labelText: "Email"),
                    ),
                    TextField(
                      controller: password,
                      obscureText: true,
                      decoration: const InputDecoration(labelText: "Password"),
                    ),
                    const SizedBox(height: 10),
                    DropdownButton<String>(
                      value: role,
                      isExpanded: true,
                      items: ["admin", "mahasiswa"]
                          .map((e) => DropdownMenuItem(
                                value: e,
                                child: Text(e),
                              ))
                          .toList(),
                      onChanged: (val) {
                        if (val != null) {
                          setState(() {
                            role = val;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed: () async {
                    if (username.text.isEmpty ||
                        email.text.isEmpty ||
                        password.text.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Semua field wajib diisi")),
                      );
                      return;
                    }

                    try {
                      await ApiService.addUser(
                        username.text,
                        email.text,
                        password.text,
                        role,
                      );
                      Navigator.pop(context);
                      fetchUsers();
                    } catch (e) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(content: Text("Gagal tambah user: $e")),
                      );
                    }
                  },
                  child: const Text("Simpan"),
                )
              ],
            );
          },
        );
      },
    );
  }

  // UI
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola User"),
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: fetchUsers,
          )
        ],
      ),
      drawer: const AdminSidebar(),
      floatingActionButton: FloatingActionButton(
        onPressed: showAddDialog,
        child: const Icon(Icons.add),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : users.isEmpty
              ? const Center(child: Text("Tidak ada user"))
              : ListView.builder(
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final u = users[index];

                    return Card(
                      margin: const EdgeInsets.all(8),
                      child: ListTile(
                        leading: CircleAvatar(
                          child: Text(u["username"][0].toUpperCase()),
                        ),
                        title: Text(u["username"]),
                        subtitle: Text(
                          "${u["email"]}\nRole: ${u["role"]}",
                        ),
                        isThreeLine: true,
                        trailing: IconButton(
                          icon: const Icon(Icons.delete, color: Colors.red),
                          onPressed: () => deleteUser(u["id"]),
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
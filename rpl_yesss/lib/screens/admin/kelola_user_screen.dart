import 'package:flutter/material.dart';

import '../../services/api_service.dart';

import '../sidebar/admin_sidebar.dart';

class KelolaUserScreen
    extends StatefulWidget {

  const KelolaUserScreen({
    super.key
  });

  @override
  State<KelolaUserScreen>
  createState() =>
      _KelolaUserScreenState();
}

class _KelolaUserScreenState
    extends State<KelolaUserScreen> {

  List users = [];

  bool isLoading = true;

  // =====================================
  // INIT
  // =====================================

  @override
  void initState() {

    super.initState();

    fetchUsers();
  }

  // =====================================
  // GET USERS
  // =====================================

  void fetchUsers() async {

    setState(() {
      isLoading = true;
    });

    try {

      final res =
          await ApiService
              .getUsers();

      setState(() {

        users = res;

        isLoading = false;
      });

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
  // DELETE USER
  // =====================================

  void deleteUser(
      int id
  ) async {

    try {

      await ApiService
          .deleteUser(id);

      fetchUsers();

    } catch (e) {

      ScaffoldMessenger.of(
          context).showSnackBar(

        SnackBar(
          content:
              Text("Gagal hapus user"),
        ),
      );
    }
  }

  // =====================================
  // ADD USER DIALOG
  // =====================================

  void showAddDialog() {

    final usernameController =
        TextEditingController();

    final emailController =
        TextEditingController();

    final passwordController =
        TextEditingController();

    String role = "mahasiswa";

    showDialog(

      context: context,

      builder: (_) {

        return StatefulBuilder(

          builder:
              (context, setStateDialog) {

            return AlertDialog(

              title:
                  const Text(
                      "Tambah User"),

              content:
                  SingleChildScrollView(

                child: Column(

                  mainAxisSize:
                      MainAxisSize.min,

                  children: [

                    TextField(

                      controller:
                          usernameController,

                      decoration:
                          const InputDecoration(
                        labelText:
                            "Username",
                      ),
                    ),

                    const SizedBox(
                        height: 12),

                    TextField(

                      controller:
                          emailController,

                      decoration:
                          const InputDecoration(
                        labelText:
                            "Email",
                      ),
                    ),

                    const SizedBox(
                        height: 12),

                    TextField(

                      controller:
                          passwordController,

                      obscureText: true,

                      decoration:
                          const InputDecoration(
                        labelText:
                            "Password",
                      ),
                    ),

                    const SizedBox(
                        height: 16),

                    DropdownButtonFormField<
                        String>(

                      value: role,

                      decoration:
                          const InputDecoration(
                        labelText:
                            "Role",
                      ),

                      items: [

                        "admin",

                        "mahasiswa"

                      ].map((e) {

                        return DropdownMenuItem(

                          value: e,

                          child: Text(e),
                        );

                      }).toList(),

                      onChanged: (v) {

                        setStateDialog(() {

                          role = v!;
                        });
                      },
                    ),
                  ],
                ),
              ),

              actions: [

                TextButton(

                  onPressed: () {

                    Navigator.pop(
                        context);
                  },

                  child:
                      const Text(
                          "Batal"),
                ),

                ElevatedButton(

                  onPressed: () async {

                    if (

                      usernameController
                          .text
                          .isEmpty ||

                      emailController
                          .text
                          .isEmpty ||

                      passwordController
                          .text
                          .isEmpty

                    ) {

                      ScaffoldMessenger.of(
                              context)
                          .showSnackBar(

                        const SnackBar(

                          content: Text(
                              "Semua field wajib diisi"),
                        ),
                      );

                      return;
                    }

                    try {

                      await ApiService
                          .addUser(

                        usernameController
                            .text,

                        emailController
                            .text,

                        passwordController
                            .text,

                        role,
                      );

                      if (mounted) {

                        Navigator.pop(
                            context);
                      }

                      fetchUsers();

                    } catch (e) {

                      ScaffoldMessenger.of(
                              context)
                          .showSnackBar(

                        SnackBar(

                          content: Text(
                              "Error: $e"),
                        ),
                      );
                    }
                  },

                  child:
                      const Text(
                          "Simpan"),
                ),
              ],
            );
          },
        );
      },
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
                "Kelola User"),

        actions: [

          IconButton(

            onPressed:
                fetchUsers,

            icon: const Icon(
                Icons.refresh),
          ),
        ],
      ),

      drawer:
          const AdminSidebar(),

      floatingActionButton:
          FloatingActionButton(

        onPressed:
            showAddDialog,

        child:
            const Icon(Icons.add),
      ),

      body: isLoading

          ? const Center(
              child:
                  CircularProgressIndicator(),
            )

          : users.isEmpty

              ? const Center(
                  child: Text(
                      "Tidak ada user"),
                )

              : ListView.builder(

                  itemCount:
                      users.length,

                  itemBuilder:
                      (context, index) {

                    final u =
                        users[index];

                    final username =
                        u["username"] ??
                            "-";

                    final email =
                        u["email"] ??
                            "-";

                    final role =
                        u["role"] ??
                            "mahasiswa";

                    return Card(

                      margin:
                          const EdgeInsets
                              .symmetric(

                        horizontal: 12,

                        vertical: 6,
                      ),

                      child: ListTile(

                        leading:
                            CircleAvatar(

                          child: Text(

                            username
                                    .isNotEmpty

                                ? username[0]
                                    .toUpperCase()

                                : "?",
                          ),
                        ),

                        title:
                            Text(username),

                        subtitle:
                            Text(

                          "$email\nRole: $role",
                        ),

                        isThreeLine: true,

                        trailing:
                            IconButton(

                          icon: const Icon(

                            Icons.delete,

                            color:
                                Colors.red,
                          ),

                          onPressed: () {

                            deleteUser(
                                u["id"]);
                          },
                        ),
                      ),
                    );
                  },
                ),
    );
  }
}
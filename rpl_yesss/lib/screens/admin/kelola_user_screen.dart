import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../services/api_service.dart';
import '../../core/providers/theme_provider.dart';
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
    final isDarkMode = Provider.of<ThemeProvider>(context).isDarkMode;

    return Scaffold(
      appBar: AppBar(
        title: const Text("Kelola User"),
        actions: [
          IconButton(
            onPressed: fetchUsers,
            icon: const Icon(Icons.refresh),
          ),
          IconButton(
            icon: Icon(isDarkMode ? Icons.light_mode : Icons.dark_mode),
            onPressed: () =>
                Provider.of<ThemeProvider>(context, listen: false)
                    .toggleTheme(),
          ),
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
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.people_outline, size: 64, color: Colors.grey[400]),
                      const SizedBox(height: 16),
                      Text(
                        "Tidak ada user",
                        style: Theme.of(context).textTheme.titleLarge,
                      ),
                    ],
                  ),
                )
              : GridView.builder(
                  padding: const EdgeInsets.all(16),
                  gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    childAspectRatio: 1.2,
                    crossAxisSpacing: 16,
                    mainAxisSpacing: 16,
                  ),
                  itemCount: users.length,
                  itemBuilder: (context, index) {
                    final u = users[index];
                    final username = u["username"] ?? "-";
                    final email = u["email"] ?? "-";
                    final role = u["role"] ?? "mahasiswa";
                    final roleColor = role == 'admin' ? Colors.red : Colors.blue;

                    return Card(
                      elevation: 4,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: InkWell(
                        borderRadius: BorderRadius.circular(12),
                        onTap: () {},
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Expanded(
                                    child: CircleAvatar(
                                      radius: 24,
                                      backgroundColor: roleColor,
                                      child: Text(
                                        username.isNotEmpty
                                            ? username[0].toUpperCase()
                                            : "?",
                                        style: const TextStyle(
                                          color: Colors.white,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 8, vertical: 4),
                                    decoration: BoxDecoration(
                                      color: roleColor.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: Text(
                                      role.toUpperCase(),
                                      style: TextStyle(
                                        color: roleColor,
                                        fontSize: 10,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const SizedBox(height: 12),
                              Text(
                                username,
                                style: Theme.of(context)
                                    .textTheme
                                    .titleSmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 4),
                              Text(
                                email,
                                style: Theme.of(context)
                                    .textTheme
                                    .bodySmall,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              ),
                              const SizedBox(height: 12),
                              SizedBox(
                                width: double.infinity,
                                child: ElevatedButton.icon(
                                  onPressed: () =>
                                      _showDeleteDialog(context, u["id"]),
                                  icon: const Icon(Icons.delete, size: 16),
                                  label: const Text('Hapus'),
                                  style: ElevatedButton.styleFrom(
                                    backgroundColor: Colors.red,
                                    foregroundColor: Colors.white,
                                    padding: const EdgeInsets.symmetric(
                                        vertical: 8),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
    );
  }

  void _showDeleteDialog(BuildContext context, int id) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hapus User'),
        content: const Text('Apakah Anda yakin ingin menghapus user ini?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Batal'),
          ),
          ElevatedButton(
            onPressed: () {
              deleteUser(id);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Hapus'),
          ),
        ],
      ),
    );
  }
}
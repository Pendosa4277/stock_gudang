import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/todo.dart';
import '../screens/detail_screen.dart';
import '../screens/login_screen.dart';
import '../services/supabase_service.dart';
import 'package:intl/intl.dart';

class HomeScreen extends StatefulWidget {
  final SupabaseService service;

  const HomeScreen({super.key, required this.service});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final supabaseClient = Supabase.instance.client;
  late final SupabaseService supabaseService;

  List<Todo> todos = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    supabaseService = SupabaseService(supabaseClient);
    _loadTodos();
  }

  Future<void> _logout() async {
    await supabaseClient.auth.signOut();

    if (!mounted) return;

    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (_) => LoginScreen(service: supabaseService)),
    );
  }

  Future<void> _loadTodos() async {
    setState(() {
      isLoading = true;
    });
    try {
      final fetchedTodos = await supabaseService.fetchTodos();
      setState(() {
        todos = fetchedTodos;
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Error load todos: $e')));
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> _addTodo(String title, DateTime deadline) async {
    final todo = Todo(
      id: '',
      title: title,
      detail: '',
      createdAt: DateTime.now(),
      deadline: deadline,
    );
    try {
      await supabaseService.addTodo(todo);
      if (!mounted) return;
      await _loadTodos();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal tambah todo: $e')));
    }
  }

  Future<void> _updateTodo(int index, Todo updatedTodo) async {
    try {
      await supabaseService.updateTodo(updatedTodo);
      if (!mounted) return;
      await _loadTodos();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal update todo: $e')));
    }
  }

  Future<void> _deleteTodo(String id) async {
    try {
      await supabaseService.deleteTodo(id);
      if (!mounted) return;
      await _loadTodos();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Gagal hapus todo: $e')));
    }
  }

  void _showAddDialog() {
    final TextEditingController controller = TextEditingController();
    DateTime? selectedDeadline;
    TimeOfDay? selectedTime;

    showDialog(
      context: context,
      builder: (context) {
        bool isInputValid = false;
        return StatefulBuilder(
          builder: (context, setState) {
            void updateIsValid() {
              final newValid =
                  controller.text.trim().isNotEmpty &&
                  selectedDeadline != null &&
                  selectedTime != null;
              if (newValid != isInputValid) {
                setState(() {
                  isInputValid = newValid;
                });
              }
            }

            return AlertDialog(
              title: const Text("Tambah Todo"),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  TextField(
                    controller: controller,
                    decoration: const InputDecoration(
                      hintText: "Tulis todo...",
                    ),
                    onChanged: (_) => updateIsValid(),
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedDeadline == null
                              ? "Pilih tanggal deadline"
                              : "Tanggal: ${selectedDeadline!.toLocal().toString().split(' ')[0]}",
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final picked = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime.now(),
                            lastDate: DateTime(2100),
                          );
                          if (picked != null) {
                            setState(() {
                              selectedDeadline = picked;
                            });
                            updateIsValid();
                          }
                        },
                        child: const Text("Pilih"),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedTime == null
                              ? "Pilih waktu deadline"
                              : "Waktu: ${selectedTime!.format(context)}",
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final pickedTime = await showTimePicker(
                            context: context,
                            initialTime: TimeOfDay.now(),
                          );
                          if (pickedTime != null) {
                            setState(() {
                              selectedTime = pickedTime;
                            });
                            updateIsValid();
                          }
                        },
                        child: const Text("Pilih"),
                      ),
                    ],
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text("Batal"),
                ),
                ElevatedButton(
                  onPressed:
                      isInputValid
                          ? () {
                            final deadline = DateTime(
                              selectedDeadline!.year,
                              selectedDeadline!.month,
                              selectedDeadline!.day,
                              selectedTime!.hour,
                              selectedTime!.minute,
                            );
                            _addTodo(controller.text.trim(), deadline);
                            Navigator.pop(context);
                          }
                          : null,
                  child: const Text("Tambah"),
                ),
              ],
            );
          },
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('GUDANG INDUK'),
        backgroundColor: Colors.yellow,
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Logout',
            onPressed: _logout,
          ),
        ],
      ),
      body:
          isLoading
              ? const Center(child: CircularProgressIndicator())
              : todos.isEmpty
              ? const Center(child: Text("Belum ada todo"))
              : ListView.builder(
                padding: const EdgeInsets.all(16),
                itemCount: todos.length,
                itemBuilder: (context, index) {
                  final todo = todos[index];
                  final formattedDeadline = DateFormat(
                    'dd MMM yyyy – HH:mm',
                  ).format(todo.deadline);

                  return Card(
                    elevation: 4,
                    margin: const EdgeInsets.symmetric(vertical: 8),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: ListTile(
                      contentPadding: const EdgeInsets.all(16),
                      title: Text(
                        todo.title,
                        style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                      subtitle: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          if (todo.detail.isNotEmpty)
                            Padding(
                              padding: const EdgeInsets.only(top: 4),
                              child: Text(todo.detail),
                            ),
                          const SizedBox(height: 6),
                          Row(
                            children: [
                              const Icon(
                                Icons.access_time,
                                size: 16,
                                color: Colors.red,
                              ),
                              const SizedBox(width: 4),
                              Text(
                                formattedDeadline,
                                style: const TextStyle(
                                  color: Colors.deepPurple,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          IconButton(
                            icon: const Icon(Icons.edit, color: Colors.blue),
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder:
                                      (context) => DetailScreen(
                                        todo: todo,
                                        onUpdate:
                                            (updatedTodo) =>
                                                _updateTodo(index, updatedTodo),
                                      ),
                                ),
                              );
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete, color: Colors.red),
                            onPressed: () => _deleteTodo(todo.id),
                          ),
                        ],
                      ),
                    ),
                  );
                },
              ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        backgroundColor: Colors.yellow,
        child: const Icon(Icons.add),
      ),
    );
  }
}

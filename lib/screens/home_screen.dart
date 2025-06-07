import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/todo.dart';
import '../screens/detail_screen.dart';
import '../services/supabase_service.dart';

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
      id: "0",
      title: title,
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

  Future<void> _deleteTodo(int id) async {
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
        return StatefulBuilder(
          builder: (context, setState) {
            bool isInputValid = false;
            void updateIsValid() {
              setState(() {
                isInputValid =
                    controller.text.trim().isNotEmpty &&
                    selectedDeadline != null &&
                    selectedTime != null;
              });
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
                  ),
                  const SizedBox(height: 10),
                  Row(
                    children: [
                      Expanded(
                        child: Text(
                          selectedDeadline == null
                              ? "pilih tanggal deadline"
                              : "Tanggal: ${selectedDeadline!.toLocal().toString().split(' ')[0]}",
                        ),
                      ),
                      TextButton(
                        onPressed: () async {
                          final DateTime? picked = await showDatePicker(
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
                          final TimeOfDay? pickedTime = await showTimePicker(
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
      appBar: AppBar(title: const Text('Daftar Todo')),
      body: ListView.builder(
        itemCount: todos.length,
        itemBuilder: (context, index) {
          final todo = todos[index];
          return ListTile(
            title: Text(todo.title),
            subtitle: Text('Deadline: ${todo.deadline.toLocal()}'),
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
                  onPressed: () {
                    _deleteTodo(int.parse(todo.id));
                  },
                ),
              ],
            ),
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder:
                      (context) => DetailScreen(
                        todo: todo,
                        onUpdate:
                            (updatedTodo) => _updateTodo(index, updatedTodo),
                      ),
                ),
              );
            },
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddDialog,
        child: const Icon(Icons.add),
      ),
    );
  }
}

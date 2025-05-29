import 'package:flutter/material.dart';
import '../models/todo.dart';
import '../screens/detail_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  List<Todo> todos = [];

  void _addTodo(String title) {
    setState(() {
      todos.add(
        Todo(
          id: DateTime.now().toString(),
          title: title,
          createdAt: DateTime.now(),
          deadline: DateTime.now().add(const Duration(days: 7)),
        ),
      );
    });
  }

  void _showAddDialog() {
    final TextEditingController controller = TextEditingController();

    showDialog(
      context: context,
      builder:
          (context) => AlertDialog(
            title: const Text("Tambah Todo"),
            content: TextField(
              controller: controller,
              decoration: const InputDecoration(hintText: "Tulis todo..."),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text("Batal"),
              ),
              ElevatedButton(
                onPressed: () {
                  if (controller.text.trim().isNotEmpty) {
                    _addTodo(controller.text.trim());
                  }
                  Navigator.pop(context);
                },
                child: const Text("Tambah"),
              ),
            ],
          ),
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
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => DetailScreen(todo: todo),
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

import 'package:flutter/material.dart';
import '../models/todo.dart';

class DetailScreen extends StatefulWidget {
  final Todo todo;

  const DetailScreen({super.key, required this.todo});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late TextEditingController titleController;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todo.title);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Detail Todo")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Judul'),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  widget.todo.title = titleController.text;
                });
                Navigator.pop(context, widget.todo);
              },
              child: const Text("Simpan"),
            ),
          ],
        ),
      ),
    );
  }
}

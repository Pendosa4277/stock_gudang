import 'package:flutter/material.dart';
import '../models/todo.dart';

class DetailScreen extends StatefulWidget {
  final Todo todo;
  final Function(Todo) onUpdate;

  const DetailScreen({super.key, required this.todo, required this.onUpdate});

  @override
  State<DetailScreen> createState() => _DetailScreenState();
}

class _DetailScreenState extends State<DetailScreen> {
  late TextEditingController titleController;
  late TextEditingController _detailController;
  late DateTime _selectedDeadline;

  bool _isInputValid = true;

  @override
  void initState() {
    super.initState();
    titleController = TextEditingController(text: widget.todo.title);
    _detailController = TextEditingController(text: widget.todo.detail);
    _selectedDeadline = widget.todo.deadline;
    _validateInput();
  }

  void _validateInput() {
    setState(() {
      _isInputValid = titleController.text.trim().isNotEmpty;
    });
  }

  void _saveChanges() {
    final updatedTodo = widget.todo.copyWith(
      title: titleController.text,
      detail: _detailController.text,
      deadline: _selectedDeadline,
    );

    widget.onUpdate(updatedTodo);
    Navigator.pop(context);
  }

  Future<void> _pickDeadlineDate() async {
    final pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDeadline,
      firstDate: DateTime.now(),
      lastDate: DateTime(2100),
    );

    if (pickedDate != null) {
      setState(() {
        _selectedDeadline = DateTime(
          pickedDate.year,
          pickedDate.month,
          pickedDate.day,
          _selectedDeadline.hour,
          _selectedDeadline.minute,
        );
      });
    }
  }

  Future<void> _pickDeadlineTime() async {
    final pickedTime = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.fromDateTime(_selectedDeadline),
    );
    if (pickedTime != null) {
      setState(() {
        // gabungkan jam baru dengan tanggal lama
        _selectedDeadline = DateTime(
          _selectedDeadline.year,
          _selectedDeadline.month,
          _selectedDeadline.day,
          pickedTime.hour,
          pickedTime.minute,
        );
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final formattedDeadline =
        "${_selectedDeadline.toLocal().toString().split('.')[0]}";

    return Scaffold(
      appBar: AppBar(title: const Text("Detail Todo")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: titleController,
              decoration: const InputDecoration(labelText: 'Judul'),
              onChanged: (_) => _validateInput(),
            ),
            TextField(
              controller: _detailController,
              decoration: const InputDecoration(labelText: "Detail"),
              maxLines: 2,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(child: Text("Deadline: $formattedDeadline")),
                TextButton(
                  onPressed: _pickDeadlineDate,
                  child: const Text("Ubah Tanggal"),
                ),
                TextButton(
                  onPressed: _pickDeadlineTime,
                  child: const Text("Ubah Waktu"),
                ),
              ],
            ),
            const Spacer(),
            ElevatedButton(
              onPressed: _isInputValid ? _saveChanges : null,
              child: const Text("Simpan Perubahan"),
            ),
          ],
        ),
      ),
    );
  }
}

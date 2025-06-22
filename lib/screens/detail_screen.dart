import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
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
    _detailController = TextEditingController(text: widget.todo.detail ?? '');
    _selectedDeadline = widget.todo.deadline;
    _validateInput();
  }

  @override
  void dispose() {
    titleController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  void _validateInput() {
    setState(() {
      _isInputValid = titleController.text.trim().isNotEmpty;
    });
  }

  void _saveChanges() {
    final updatedTodo = widget.todo.copyWith(
      title: titleController.text.trim(),
      detail: _detailController.text.trim(),
      deadline: _selectedDeadline,
    );

    widget.onUpdate(updatedTodo);

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(content: Text('Perubahan berhasil disimpan')),
    );

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
    final formattedDeadline = DateFormat(
      'EEEE, dd MMM yyyy – HH:mm',
    ).format(_selectedDeadline);

    return Scaffold(
      appBar: AppBar(
        title: const Text("Detail Todo"),
        backgroundColor: Colors.deepPurple,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Card(
          elevation: 8,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                TextField(
                  controller: titleController,
                  decoration: InputDecoration(
                    labelText: 'Judul',
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onChanged: (_) => _validateInput(),
                  autofocus: true,
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: _detailController,
                  maxLines: 3,
                  decoration: InputDecoration(
                    labelText: "Detail",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                ),
                const SizedBox(height: 24),
                Row(
                  children: [
                    const Icon(Icons.calendar_today, color: Colors.deepPurple),
                    const SizedBox(width: 8),
                    Expanded(
                      child: Text(
                        "Deadline: $formattedDeadline",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.edit_calendar,
                        color: Colors.deepPurple,
                      ),
                      onPressed: _pickDeadlineDate,
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.access_time,
                        color: Colors.deepPurple,
                      ),
                      onPressed: _pickDeadlineTime,
                    ),
                  ],
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 48,
                  child: ElevatedButton.icon(
                    onPressed: _isInputValid ? _saveChanges : null,
                    icon: const Icon(Icons.save),
                    label: const Text("Simpan Perubahan"),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.deepPurple,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                      textStyle: const TextStyle(fontSize: 16),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

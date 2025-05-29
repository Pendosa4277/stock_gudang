import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import '../models/todo.dart';

class TodoProvider extends ChangeNotifier {
  final List<Todo> _todos = [];
  final Uuid _uuid = Uuid();

  List<Todo> get todos => _todos;

  void addTodo(String title, DateTime deadline) {
    _todos.add(
      Todo(
        id: _uuid.v4(),
        title: title,
        createdAt: DateTime.now(),
        deadline: deadline,
      ),
    );
    notifyListeners();
  }

  void editTodo(
    int index,
    String newTitle,
    DateTime newDeadline,
    String detail,
  ) {
    final todo = _todos[index];
    todo.title = newTitle;
    todo.deadline = newDeadline;
    todo.detail = detail;
    notifyListeners();
  }

  void deleteTodo(int index) {
    _todos.removeAt(index);
    notifyListeners();
  }

  void restoreTodo(int index, Todo todo) {
    _todos.insert(index, todo);
    notifyListeners();
  }

  void toggleCompleted(int index) {
    _todos[index].completed = !_todos[index].completed;
    notifyListeners();
  }
}

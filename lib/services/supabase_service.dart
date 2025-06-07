import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/todo.dart';

class SupabaseService {
  final SupabaseClient supabase;

  SupabaseService(this.supabase);

  Future<List<Todo>> fetchTodos() async {
    try {
      final response = await supabase.from('todos').select();
      return (response as List<dynamic>)
          .map((item) => Todo.fromMap(item))
          .toList();
    } catch (e) {
      throw Exception('Failed to fetch todos: $e');
    }
  }

  Future<void> addTodo(Todo todo) async {
    try {
      await supabase.from('todos').insert(todo.toMap());
    } catch (e) {
      throw Exception('Failed to add todo: $e');
    }
  }

  Future<void> updateTodo(Todo todo) async {
    try {
      await supabase.from('todos').update(todo.toMap()).eq('id', todo.id);
    } catch (e) {
      throw Exception('Failed to update todo: $e');
    }
  }

  Future<void> deleteTodo(int id) async {
    try {
      await supabase.from('todos').delete().eq('id', id);
    } catch (e) {
      throw Exception('Failed to delete todo: $e');
    }
  }
}

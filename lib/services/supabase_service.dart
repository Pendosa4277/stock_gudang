import 'package:supabase_flutter/supabase_flutter.dart';
import '../models/todo.dart';

class SupabaseService {
  final SupabaseClient supabase;

  SupabaseService(this.supabase);

  Future<List<Todo>> fetchTodos() async {
    final response = await supabase
        .from('todos')
        .select()
        .order('created_at', ascending: false);
    return (response as List<dynamic>)
        .map((item) => Todo.fromMap(item))
        .toList();
  }

  Future<void> addTodo(Todo todo) async {
    final user = supabase.auth.currentUser;

    if (user == null) {
      throw Exception('User not logged in');
    }

    await supabase.from('todos').insert({
      'id': todo.id,
      'title': todo.title,
      'detail': todo.detail,
      'created_at': todo.createdAt.toIso8601String(),
      'deadline': todo.deadline.toIso8601String(),
      'user_id': user.id,
    });
  }

  Future<void> updateTodo(Todo todo) async {
    await supabase
        .from('todos')
        .update({
          'title': todo.title,
          'detail': todo.detail,
          'deadline': todo.deadline.toIso8601String(),
        })
        .eq('id', todo.id);
  }

  Future<void> deleteTodo(String id) async {
    await supabase.from('todos').delete().eq('id', id);
  }
}

class Todo {
  final String id;
  String title;
  DateTime createdAt;
  DateTime deadline;
  String detail;
  bool completed;

  Todo({
    required this.id,
    required this.title,
    required this.createdAt,
    required this.deadline,
    this.detail = '',
    this.completed = false,
  });
  Todo copyWith({
    String? id,
    String? title,
    DateTime? createdAt,
    DateTime? deadline,
    String? detail,
    bool? completed,
  }) {
    return Todo(
      id: id ?? this.id,
      title: title ?? this.title,
      createdAt: createdAt ?? this.createdAt,
      deadline: deadline ?? this.deadline,
      detail: detail ?? this.detail,
      completed: completed ?? this.completed,
    );
  }

  factory Todo.fromMap(Map<String, dynamic> map) {
    return Todo(
      id: map['id'] as String,
      title: map['title'] as String,
      createdAt: DateTime.parse(map['created_at'] as String),
      deadline: DateTime.parse(map['deadline'] as String),
      detail: map['detail'] as String? ?? '',
      completed: map['completed'] as bool? ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'title': title,
      'created_at': createdAt.toIso8601String(),
      'deadline': deadline.toIso8601String(),
      'detail': detail,
      'completed': completed,
    };
  }
}

class Todo {
  String id;
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
}

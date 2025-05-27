class Todo {
  String title;
  DateTime createdAt;
  DateTime deadline;
  bool completed;
  String? detail;

  Todo({
    required this.title,
    required this.createdAt,
    required this.deadline,
    this.completed = false,
    this.detail,
  });
}

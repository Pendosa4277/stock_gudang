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
}

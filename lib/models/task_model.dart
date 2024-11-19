class Task {
  String title;
  bool isCompleted;

  Task({
    required this.title,
    required this.isCompleted,
  });

  void isDone() {
    isCompleted = !isCompleted;
  }

  Task copyWith({
    String? title,
    bool? isCompleted,
  }) {
    return Task(
      title: title ?? this.title,
      isCompleted: isCompleted ?? this.isCompleted,
    );
  }

  factory Task.fromMap(Map<String, dynamic> map) {
    return Task(
      title: map['title'] ?? '',
      isCompleted: map['isCompleted'] ?? false,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'title': title,
      'isCompleted': isCompleted,
    };
  }

  @override
  String toString() {
    return 'Task(title: $title, isCompleted: $isCompleted)';
  }
}

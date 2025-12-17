enum TaskType { hydration, movement, facial, nutrition }

class RegimenTask {
  final String id;
  final String title;
  final String description;
  final TaskType type;
  final bool isCompleted;
  final DateTime scheduledTime;

  RegimenTask({
    required this.id,
    required this.title,
    required this.description,
    required this.type,
    this.isCompleted = false,
    required this.scheduledTime,
  });

  // Helper to toggle status easily (since entities should be immutable)
  RegimenTask copyWith({bool? isCompleted}) {
    return RegimenTask(
      id: id,
      title: title,
      description: description,
      type: type,
      isCompleted: isCompleted ?? this.isCompleted,
      scheduledTime: scheduledTime,
    );
  }
}

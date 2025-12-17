import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/entities/regimen_task.dart';

class TaskModel extends RegimenTask {
  TaskModel({
    required super.id,
    required super.title,
    required super.description,
    required super.type,
    required super.isCompleted,
    required super.scheduledTime,
  });

  // MAPPER: From Firestore Document to Domain Entity
  factory TaskModel.fromFirestore(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;
    return TaskModel(
      id: doc.id,
      title: data['title'] ?? '',
      description: data['description'] ?? '',
      type: TaskType.values.firstWhere((e) => e.toString() == data['type']),
      isCompleted: data['isCompleted'] ?? false,
      scheduledTime: (data['scheduledTime'] as Timestamp).toDate(),
    );
  }

  // MAPPER: From Domain Entity to JSON (for writing to DB)
  Map<String, dynamic> toFirestore() {
    return {
      'title': title,
      'description': description,
      'type': type.toString(),
      'isCompleted': isCompleted,
      'scheduledTime': Timestamp.fromDate(scheduledTime),
    };
  }
}

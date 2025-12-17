import 'package:cloud_firestore/cloud_firestore.dart';
import '../../domain/repositories/i_regimen_repository.dart';
import '../../domain/entities/regimen_task.dart';
import '../models/task_model.dart';

class FirebaseRegimenRepository implements IRegimenRepository {
  final FirebaseFirestore _firestore;
  final String userId; // Injected dependency

  FirebaseRegimenRepository(this._firestore, this.userId);

  @override
  Stream<List<RegimenTask>> getDailyTasks(DateTime date) {
    // OFFLINE FIRST MAGIC:
    // Firestore automatically checks local cache first, then syncs with server.
    // The stream emits the cached data immediately.

    // Logic: Convert Date to a string key like "2023-10-27" to query that day's subcollection
    final dateKey = "${date.year}-${date.month}-${date.day}";

    return _firestore
        .collection('users')
        .doc(userId)
        .collection('daily_logs')
        .doc(dateKey)
        .collection('tasks')
        .orderBy('scheduledTime')
        .snapshots()
        .map((snapshot) {
          return snapshot.docs
              .map((doc) => TaskModel.fromFirestore(doc))
              .toList();
        });
  }

  @override
  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    // Even if offline, this write is queued locally and syncs later.
    // The UI updates optimistically because of the Stream listener above.
    final date = DateTime.now();
    final dateKey = "${date.year}-${date.month}-${date.day}";

    await _firestore
        .collection('users')
        .doc(userId)
        .collection('daily_logs')
        .doc(dateKey)
        .collection('tasks')
        .doc(taskId)
        .update({'isCompleted': isCompleted});
  }

  @override
  Future<void> resetDailyTasks() async {
    // Logic to copy template tasks to today's list
  }
}

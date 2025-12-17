import '../entities/regimen_task.dart';

abstract class IRegimenRepository {
  // Returns a Stream so UI updates instantly (Reactive)
  Stream<List<RegimenTask>> getDailyTasks(DateTime date);

  // Actions
  Future<void> toggleTaskCompletion(String taskId, bool isCompleted);
  Future<void> resetDailyTasks();
}

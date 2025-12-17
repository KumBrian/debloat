import '../../domain/repositories/i_regimen_repository.dart';
import '../../domain/entities/regimen_task.dart';

class MockRegimenRepository implements IRegimenRepository {
  // In-memory store for the session
  final List<RegimenTask> _mockTasks = [
    RegimenTask(
      id: '1',
      title: 'Thermal Shock',
      description: 'Ice water face dip',
      type: TaskType.facial,
      scheduledTime: DateTime.now().copyWith(hour: 7, minute: 0),
    ),
    RegimenTask(
      id: '2',
      title: 'Lemon Water',
      description: '500ml hydration',
      type: TaskType.hydration,
      scheduledTime: DateTime.now().copyWith(hour: 7, minute: 15),
    ),
  ];

  @override
  Stream<List<RegimenTask>> getDailyTasks(DateTime date) {
    // Simulate network delay strictly for realism, then return data
    return Stream.value(_mockTasks).asBroadcastStream();
  }

  @override
  Future<void> toggleTaskCompletion(String taskId, bool isCompleted) async {
    // Update local list to simulate behavior
    final index = _mockTasks.indexWhere((t) => t.id == taskId);
    if (index != -1) {
      _mockTasks[index] = _mockTasks[index].copyWith(isCompleted: isCompleted);
    }
  }

  @override
  Future<void> resetDailyTasks() async {}
}

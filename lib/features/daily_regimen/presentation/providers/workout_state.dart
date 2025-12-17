import '../../domain/entities/workout_entity.dart';

enum WorkoutStatus { initial, inProgress, paused, completed }

class WorkoutState {
  final WorkoutStatus status;
  final int currentExerciseIndex;
  final int secondsRemaining;
  final bool isResting; // True = Red/Rest, False = Green/Work
  final List<Exercise> circuit;

  // Helpers
  Exercise get currentExercise => circuit[currentExerciseIndex];

  // Logic to calculate progress (0.0 to 1.0) for the Circular Ring
  double get progressPercent {
    final total = isResting ? 15 : currentExercise.durationSeconds;
    return (total - secondsRemaining) / total;
  }

  Exercise? get nextExercise {
    if (currentExerciseIndex + 1 < circuit.length) {
      return circuit[currentExerciseIndex + 1];
    }
    return null; // Finished
  }

  const WorkoutState({
    required this.status,
    required this.currentExerciseIndex,
    required this.secondsRemaining,
    required this.isResting,
    required this.circuit,
  });

  // Factory for initial state
  factory WorkoutState.initial() {
    return WorkoutState(
      status: WorkoutStatus.initial,
      currentExerciseIndex: 0,
      secondsRemaining: 45, // Default start time
      isResting: false,
      circuit: metabolicCircuit,
    );
  }

  WorkoutState copyWith({
    WorkoutStatus? status,
    int? currentExerciseIndex,
    int? secondsRemaining,
    bool? isResting,
  }) {
    return WorkoutState(
      status: status ?? this.status,
      currentExerciseIndex: currentExerciseIndex ?? this.currentExerciseIndex,
      secondsRemaining: secondsRemaining ?? this.secondsRemaining,
      isResting: isResting ?? this.isResting,
      circuit: circuit,
    );
  }
}

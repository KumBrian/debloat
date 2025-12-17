// features/daily_regimen/presentation/providers/workout_controller.dart
import 'dart:async';
import 'package:riverpod_annotation/riverpod_annotation.dart';
import 'workout_state.dart';

part 'workout_controller.g.dart';

@riverpod
class WorkoutController extends _$WorkoutController {
  Timer? _timer;
  static const int _restDuration = 15;

  @override
  WorkoutState build() {
    // Cleanup when provider is disposed
    ref.onDispose(() {
      _timer?.cancel();
    });

    return WorkoutState.initial();
  }

  // --- ACTIONS ---

  void togglePause() {
    if (state.status == WorkoutStatus.inProgress) {
      _pause();
    } else {
      _start();
    }
  }

  void skipForward() {
    _timer?.cancel();
    _moveToNextPhase();
  }

  void skipBackward() {
    // Basic logic: restart current or go back
    state = state.copyWith(
      secondsRemaining: state.isResting
          ? _restDuration
          : state.currentExercise.durationSeconds,
    );
  }

  // --- INTERNAL LOGIC ---

  void _start() {
    state = state.copyWith(status: WorkoutStatus.inProgress);
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _tick();
    });
  }

  void _pause() {
    _timer?.cancel();
    state = state.copyWith(status: WorkoutStatus.paused);
  }

  void _tick() {
    if (state.secondsRemaining > 1) {
      state = state.copyWith(secondsRemaining: state.secondsRemaining - 1);
    } else {
      // Phase Finished
      _moveToNextPhase();
    }
  }

  void _moveToNextPhase() {
    // 1. If we were Resting -> Start Next Work
    if (state.isResting) {
      // Check if workout is done
      if (state.currentExerciseIndex >= state.circuit.length - 1) {
        _completeWorkout();
      } else {
        // Move to next exercise
        final nextIndex = state.currentExerciseIndex + 1;
        state = state.copyWith(
          isResting: false,
          currentExerciseIndex: nextIndex,
          secondsRemaining: state.circuit[nextIndex].durationSeconds,
        );
      }
    }
    // 2. If we were Working -> Start Rest
    else {
      state = state.copyWith(isResting: true, secondsRemaining: _restDuration);
      // Optional: Trigger "Rest" Audio cue here
    }
  }

  void _completeWorkout() {
    _timer?.cancel();
    state = state.copyWith(
      status: WorkoutStatus.completed,
      secondsRemaining: 0,
    );
  }
}

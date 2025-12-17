// features/daily_regimen/presentation/providers.dart
import 'package:debloat/features/daily_regimen/data/repositories/firebase_regimen_repository.dart';
import 'package:debloat/features/daily_regimen/data/repositories/mock_regimen_repository.dart';
import 'package:debloat/features/daily_regimen/domain/entities/regimen_task.dart';
import 'package:debloat/features/daily_regimen/domain/repositories/i_regimen_repository.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';

// 1. Config Provider (Toggle this to switch modes)
final isDemoModeProvider = Provider<bool>((ref) => true);

// 2. Firebase Dependencies
final firestoreProvider = Provider((ref) => FirebaseFirestore.instance);
final authProvider = Provider((ref) => FirebaseAuth.instance);

// 3. Repository Provider (The Brain)
final regimenRepositoryProvider = Provider<IRegimenRepository>((ref) {
  final isDemo = ref.watch(isDemoModeProvider);

  if (isDemo) {
    return MockRegimenRepository();
  } else {
    final firestore = ref.watch(firestoreProvider);
    final user = ref.watch(authProvider).currentUser;
    if (user == null) throw Exception("User not logged in");

    return FirebaseRegimenRepository(firestore, user.uid);
  }
});

// 4. Controller/Stream Provider (The UI consumes this)
final dailyTasksProvider = StreamProvider.autoDispose
    .family<List<RegimenTask>, DateTime>((ref, date) {
      final repository = ref.watch(regimenRepositoryProvider);
      return repository.getDailyTasks(date);
    });

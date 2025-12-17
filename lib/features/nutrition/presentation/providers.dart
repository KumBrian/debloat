// features/nutrition/presentation/providers.dart
import 'package:debloat/features/nutrition/data/data_sources/ai_remote_service.dart';
import 'package:debloat/features/nutrition/domain/entities/grocery_item.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter_riverpod/legacy.dart';
import '../data/repositories/nutrition_repository_impl.dart';

// 1. Dependency Providers (Core Services)
final firestoreProvider = Provider<FirebaseFirestore>((ref) {
  return FirebaseFirestore.instance;
});

final authProvider = Provider<FirebaseAuth>((ref) {
  return FirebaseAuth.instance;
});

final aiServiceProvider = Provider<AiRemoteService>((ref) {
  return AiRemoteService();
});

// 2. Repository Provider
// Relies on Auth to get the User ID.
// If user is null, it throws an error (handled by UI Auth guards).
final nutritionRepositoryProvider = Provider<NutritionRepositoryImpl>((ref) {
  final firestore = ref.watch(firestoreProvider);
  final aiService = ref.watch(aiServiceProvider);
  final user = ref.watch(authProvider).currentUser;

  if (user == null) {
    throw Exception(
      "Cannot initialize NutritionRepository: User is logged out.",
    );
  }

  return NutritionRepositoryImpl(
    firestore: firestore,
    aiService: aiService,
    userId: user.uid,
  );
});

// 3. Data Stream Provider (Read)
// The UI listens to this. It yields the NutritionPlan or null/loading.
final groceryListStreamProvider = StreamProvider.autoDispose<NutritionPlan?>((
  ref,
) {
  // Use .watch so if the repo changes (user logs out/in), this updates
  final repository = ref.watch(nutritionRepositoryProvider);
  return repository.getLastGroceryList();
});

// 4. Controller Provider (Write)
// Manages the state of the "Generate" button (Loading vs Data vs Error)
final nutritionControllerProvider =
    StateNotifierProvider<NutritionController, AsyncValue<void>>((ref) {
      final repository = ref.watch(nutritionRepositoryProvider);
      return NutritionController(repository);
    });

class NutritionController extends StateNotifier<AsyncValue<void>> {
  final NutritionRepositoryImpl _repository;

  NutritionController(this._repository) : super(const AsyncValue.data(null));

  Future<void> generateList(String preferences) async {
    state = const AsyncValue.loading();
    try {
      await _repository.generateNewPlan(preferences);
      state = const AsyncValue.data(null);
    } catch (e, stackTrace) {
      state = AsyncValue.error(e, stackTrace);
    }
  }
}

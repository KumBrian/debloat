// features/nutrition/data/repositories/nutrition_repository_impl.dart
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:debloat/features/nutrition/data/data_sources/ai_remote_service.dart';

import '../../domain/entities/grocery_item.dart';

class NutritionRepositoryImpl {
  final FirebaseFirestore _firestore;
  final AiRemoteService _aiService;
  final String userId;

  NutritionRepositoryImpl({
    required FirebaseFirestore firestore,
    required AiRemoteService aiService,
    required this.userId,
  }) : _firestore = firestore,
       _aiService = aiService;

  /// 1. GET (Works Offline)
  /// Returns a stream of the most recent plan from local cache/db.
  Stream<NutritionPlan?> getLastGroceryList() {
    return _firestore
        .collection('users')
        .doc(userId)
        .collection('nutrition')
        .orderBy('generatedDate', descending: true)
        .limit(1)
        .snapshots()
        .map((snapshot) {
          if (snapshot.docs.isEmpty) return null;
          return _mapDocToEntity(snapshot.docs.first);
        });
  }

  /// 2. GENERATE (Requires Online)
  /// Generates data via AI, then saves to Firestore.
  Future<void> generateNewPlan(String preferences) async {
    try {
      // Step A: Call AI
      final jsonResult = await _aiService.generateGroceryList(preferences);

      // Step B: Save to Firestore
      // We do not return the object here. We save it, and the Stream above updates the UI.
      await _firestore
          .collection('users')
          .doc(userId)
          .collection('nutrition')
          .add({
            'generatedDate': FieldValue.serverTimestamp(),
            'items': jsonResult['items'], // List<Map>
            'bannedFoodsAvoided': jsonResult['banned_avoided'], // List<String>
          });
    } catch (e) {
      throw Exception("Could not generate plan: $e");
    }
  }

  /// 3. MAPPER (Private Helper)
  /// Converts the raw Firestore document into our strict Domain Entity.
  NutritionPlan _mapDocToEntity(DocumentSnapshot doc) {
    final data = doc.data() as Map<String, dynamic>;

    final rawItems = data['items'] as List<dynamic>? ?? [];
    final groceryItems = rawItems.map((item) {
      final itemMap = item as Map<String, dynamic>;
      return GroceryItem(
        name: itemMap['name'] ?? 'Unknown Item',
        category: itemMap['category'] ?? 'General',
        // Default to false if key is missing
        isBought: itemMap['isBought'] ?? false,
      );
    }).toList();

    final rawBanned = data['bannedFoodsAvoided'] as List<dynamic>? ?? [];
    final bannedList = rawBanned.map((e) => e.toString()).toList();

    return NutritionPlan(
      id: doc.id,
      generatedDate:
          (data['generatedDate'] as Timestamp?)?.toDate() ?? DateTime.now(),
      items: groceryItems,
      bannedFoodsAvoided: bannedList,
    );
  }

  Future<void> toggleGroceryItem(
    String planId,
    GroceryItem itemToToggle,
  ) async {
    // Reference to the specific plan document
    final docRef = _firestore
        .collection('users')
        .doc(userId)
        .collection('nutrition')
        .doc(planId);

    // A. Get current data (Read)
    // We use .get() which leverages the cache if offline
    final snapshot = await docRef.get();

    if (!snapshot.exists) {
      throw Exception("Nutrition plan not found");
    }

    final data = snapshot.data() as Map<String, dynamic>;
    final rawItems = data['items'] as List<dynamic>? ?? [];

    // B. Modify data (Modify)
    // We map over the raw list. When we find the matching item, we toggle 'isBought'.
    final updatedItems = rawItems.map((rawItem) {
      final itemMap = rawItem as Map<String, dynamic>;

      // We identify the item by name and category (since we don't have unique IDs for items)
      if (itemMap['name'] == itemToToggle.name &&
          itemMap['category'] == itemToToggle.category) {
        return {
          'name': itemMap['name'],
          'category': itemMap['category'],
          'isBought': !itemToToggle.isBought, // Toggle the boolean
        };
      }
      return itemMap; // Return unchanged
    }).toList();

    // C. Update Firestore (Write)
    // We strictly update ONLY the 'items' field to minimize bandwidth
    await docRef.update({'items': updatedItems});
  }
}

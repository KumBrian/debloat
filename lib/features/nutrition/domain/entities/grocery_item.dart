class GroceryItem {
  final String name;
  final String category;
  final bool isBought;

  GroceryItem({
    required this.name,
    required this.category,
    this.isBought = false,
  });

  // Helper for UI to create a copy with new status
  GroceryItem copyWith({bool? isBought}) {
    return GroceryItem(
      name: name,
      category: category,
      isBought: isBought ?? this.isBought,
    );
  }

  // Equality override ensures simple comparison
  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GroceryItem &&
        other.name == name &&
        other.category == category &&
        other.isBought == isBought;
  }

  @override
  int get hashCode => Object.hash(name, category, isBought);
}

// features/nutrition/domain/entities/nutrition_plan.dart
class NutritionPlan {
  final String id;
  final DateTime generatedDate;
  final List<GroceryItem> items;
  final List<String>
  bannedFoodsAvoided; // Metadata for the user to see what was filtered

  NutritionPlan({
    required this.id,
    required this.generatedDate,
    required this.items,
    required this.bannedFoodsAvoided,
  });
}

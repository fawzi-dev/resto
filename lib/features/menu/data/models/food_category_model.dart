import '../../domain/entities/food_category.dart';

class FoodCategoryModel extends FoodCategory {
  const FoodCategoryModel({
    required super.id,
    required super.name,
    required super.icon,
  });

  factory FoodCategoryModel.fromJson(Map<String, dynamic> json) {
    return FoodCategoryModel(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: _iconFromKey(json['icon'] as String?),
    );
  }

  factory FoodCategoryModel.fromEntity(FoodCategory category) {
    return FoodCategoryModel(
      id: category.id,
      name: category.name,
      icon: category.icon,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'icon': icon.name,
      };

  static CategoryIcon _iconFromKey(String? key) {
    return CategoryIcon.values.firstWhere(
      (icon) => icon.name == key,
      orElse: () => CategoryIcon.other,
    );
  }
}

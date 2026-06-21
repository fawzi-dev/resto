import '../../domain/entities/food_item.dart';

class FoodItemModel extends FoodItem {
  const FoodItemModel({
    required super.id,
    required super.name,
    required super.description,
    required super.imageUrl,
    required super.price,
    required super.categoryId,
  });

  factory FoodItemModel.fromJson(Map<String, dynamic> json) {
    return FoodItemModel(
      id: json['id'] as String,
      name: json['name'] as String,
      description: json['description'] as String? ?? '',
      imageUrl: json['image_url'] as String,
      price: (json['price'] as num).toInt(),
      categoryId: json['category_id'] as String,
    );
  }

  factory FoodItemModel.fromEntity(FoodItem item) {
    return FoodItemModel(
      id: item.id,
      name: item.name,
      description: item.description,
      imageUrl: item.imageUrl,
      price: item.price,
      categoryId: item.categoryId,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'description': description,
        'image_url': imageUrl,
        'price': price,
        'category_id': categoryId,
      };
}

import '../entities/food_category.dart';
import '../entities/food_item.dart';

abstract interface class MenuRepository {
  Future<List<FoodCategory>> fetchCategories();
  Future<List<FoodItem>> fetchFoods({String? categoryId});

  Future<FoodCategory> createCategory(FoodCategory category);
  Future<FoodItem> createFood(FoodItem food);
  Future<FoodItem> updateFood(FoodItem food);
  Future<void> deleteFood(String id);
}

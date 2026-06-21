import '../../../../core/network/failure.dart';
import '../../domain/entities/food_category.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/repositories/menu_repository.dart';
import '../datasources/menu_remote_data_source.dart';
import '../models/food_category_model.dart';
import '../models/food_item_model.dart';

class MenuRepositoryImpl implements MenuRepository {
  const MenuRepositoryImpl(this._remote);

  final MenuRemoteDataSource _remote;

  @override
  Future<List<FoodCategory>> fetchCategories() {
    return _guard(_remote.getCategories);
  }

  @override
  Future<List<FoodItem>> fetchFoods({String? categoryId}) {
    return _guard(() => _remote.getFoods(categoryId: categoryId));
  }

  @override
  Future<FoodCategory> createCategory(FoodCategory category) {
    return _guard(
      () => _remote.createCategory(FoodCategoryModel.fromEntity(category)),
    );
  }

  @override
  Future<FoodItem> createFood(FoodItem food) {
    return _guard(() => _remote.createFood(FoodItemModel.fromEntity(food)));
  }

  @override
  Future<FoodItem> updateFood(FoodItem food) {
    return _guard(() => _remote.updateFood(FoodItemModel.fromEntity(food)));
  }

  @override
  Future<void> deleteFood(String id) {
    return _guard(() => _remote.deleteFood(id));
  }

  // Turn whatever the data source throws into a typed Failure so the UI only
  // ever has to deal with one error shape.
  Future<T> _guard<T>(Future<T> Function() action) async {
    try {
      return await action();
    } on Failure {
      rethrow;
    } catch (error) {
      throw UnknownFailure(error.toString());
    }
  }
}

import '../../../../core/network/api_client.dart';
import '../models/food_category_model.dart';
import '../models/food_item_model.dart';

abstract interface class MenuRemoteDataSource {
  Future<List<FoodCategoryModel>> getCategories();
  Future<List<FoodItemModel>> getFoods({String? categoryId});
  Future<FoodCategoryModel> createCategory(FoodCategoryModel category);
  Future<FoodItemModel> createFood(FoodItemModel food);
  Future<FoodItemModel> updateFood(FoodItemModel food);
  Future<void> deleteFood(String id);
}

// In-memory backend used as the offline default. Same JSON shape the real API
// returns, plus a bit of latency so the loading/skeleton states show.
class FakeMenuRemoteDataSource implements MenuRemoteDataSource {
  FakeMenuRemoteDataSource({this.latency = const Duration(milliseconds: 700)});

  final Duration latency;

  late final List<FoodCategoryModel> _categories =
      _categoriesJson.map(FoodCategoryModel.fromJson).toList();
  late final List<FoodItemModel> _foods =
      _foodsJson.map(FoodItemModel.fromJson).toList();

  @override
  Future<List<FoodCategoryModel>> getCategories() async {
    await Future<void>.delayed(latency);
    return List.of(_categories);
  }

  @override
  Future<List<FoodItemModel>> getFoods({String? categoryId}) async {
    await Future<void>.delayed(latency);
    if (categoryId == null) return List.of(_foods);
    return _foods.where((f) => f.categoryId == categoryId).toList();
  }

  @override
  Future<FoodCategoryModel> createCategory(FoodCategoryModel category) async {
    await Future<void>.delayed(latency);
    _categories.add(category);
    return category;
  }

  @override
  Future<FoodItemModel> createFood(FoodItemModel food) async {
    await Future<void>.delayed(latency);
    _foods.insert(0, food);
    return food;
  }

  @override
  Future<FoodItemModel> updateFood(FoodItemModel food) async {
    await Future<void>.delayed(latency);
    final index = _foods.indexWhere((f) => f.id == food.id);
    if (index != -1) _foods[index] = food;
    return food;
  }

  @override
  Future<void> deleteFood(String id) async {
    await Future<void>.delayed(latency);
    _foods.removeWhere((f) => f.id == id);
  }

  static String _photo(String id) =>
      'https://images.unsplash.com/photo-$id?auto=format&fit=crop&w=500&q=70';

  static const List<Map<String, dynamic>> _categoriesJson = [
    {'id': 'pizza', 'name': 'پیتزا', 'icon': 'pizza'},
    {'id': 'burger', 'name': 'بەرگر', 'icon': 'burger'},
    {'id': 'shawarma', 'name': 'شاورمە', 'icon': 'shawarma'},
    {'id': 'salad', 'name': 'زەڵاتە', 'icon': 'salad'},
    {'id': 'drinks', 'name': 'خواردنەوە', 'icon': 'drink'},
    {'id': 'dessert', 'name': 'شیرینی', 'icon': 'dessert'},
  ];

  static final List<Map<String, dynamic>> _foodsJson = [
    {'id': 'f1', 'name': 'شاورمەی گۆشت', 'description': 'شاورمەی گۆشتی تازە لەگەڵ سۆس و سەوزە', 'image_url': _photo('1561758033-d89a9ad46330'), 'price': 8000, 'category_id': 'shawarma'},
    {'id': 'f2', 'name': 'بەرگر دبل پەنیر', 'description': 'بەرگری تایبەت و دبل پەنیر', 'image_url': _photo('1568901346375-23c9450c58cd'), 'price': 9500, 'category_id': 'burger'},
    {'id': 'f3', 'name': 'زەڵاتەی ئەمریکی', 'description': 'زەڵاتەی تازە لەگەڵ سۆسی تایبەت', 'image_url': _photo('1512621776951-a57141f2eefd'), 'price': 5000, 'category_id': 'salad'},
    {'id': 'f4', 'name': 'پیتزای مارگاریتا', 'description': 'پیتزا لەگەڵ پەنیری مۆزارێلا و باسیل', 'image_url': _photo('1513104890138-7c749659a591'), 'price': 12000, 'category_id': 'pizza'},
    {'id': 'f5', 'name': 'پیتزای پەپەرۆنی', 'description': 'پیتزا لەگەڵ پەپەرۆنی و پەنیری زۆر', 'image_url': _photo('1565299624946-b28f40a0ae38'), 'price': 13000, 'category_id': 'pizza'},
    {'id': 'f6', 'name': 'بەرگری مریشک', 'description': 'بەرگری مریشکی برژاو لەگەڵ سۆسی تایبەت', 'image_url': _photo('1606755962773-d324e0a13086'), 'price': 8500, 'category_id': 'burger'},
    {'id': 'f7', 'name': 'شاورمەی مریشک', 'description': 'شاورمەی مریشک لەگەڵ سیر و ترشی', 'image_url': _photo('1559847844-5315695dadae'), 'price': 7000, 'category_id': 'shawarma'},
    {'id': 'f8', 'name': 'زەڵاتەی سیزەر', 'description': 'زەڵاتەی سیزەر لەگەڵ مریشک و پەنیری پارمیزان', 'image_url': _photo('1550304943-4f24f54ddde9'), 'price': 6500, 'category_id': 'salad'},
    {'id': 'f9', 'name': 'شەربەتی پرتەقاڵ', 'description': 'شەربەتی پرتەقاڵی سروشتی و تازە', 'image_url': _photo('1613478223719-2ab802602423'), 'price': 3000, 'category_id': 'drinks'},
    {'id': 'f10', 'name': 'مۆیتۆی لیمۆ', 'description': 'خواردنەوەیەکی ساردی تازەکەرەوە', 'image_url': _photo('1437418747212-8d9709afab22'), 'price': 4000, 'category_id': 'drinks'},
    {'id': 'f11', 'name': 'کێکی شکۆلاتە', 'description': 'کێکی شکۆلاتەی گەرم لەگەڵ ئایس کرێم', 'image_url': _photo('1578985545062-69928b1d9587'), 'price': 5500, 'category_id': 'dessert'},
    {'id': 'f12', 'name': 'چیز کێک', 'description': 'چیز کێکی نیویۆرکی لەگەڵ فڕاولە', 'image_url': _photo('1533134242443-d4fd215305ad'), 'price': 6000, 'category_id': 'dessert'},
  ];
}

// Talks to the real REST API (the bundled mock_api server, or any backend with
// the same contract) through [ApiClient].
class HttpMenuRemoteDataSource implements MenuRemoteDataSource {
  const HttpMenuRemoteDataSource(this._client);

  final ApiClient _client;

  @override
  Future<List<FoodCategoryModel>> getCategories() async {
    final data = await _client.get('/categories') as List<dynamic>;
    return data
        .map((e) => FoodCategoryModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<List<FoodItemModel>> getFoods({String? categoryId}) async {
    final data = await _client.get(
      '/foods',
      query: categoryId == null ? null : {'category_id': categoryId},
    ) as List<dynamic>;
    return data
        .map((e) => FoodItemModel.fromJson(e as Map<String, dynamic>))
        .toList();
  }

  @override
  Future<FoodCategoryModel> createCategory(FoodCategoryModel category) async {
    final data = await _client.post('/categories', body: category.toJson());
    return FoodCategoryModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<FoodItemModel> createFood(FoodItemModel food) async {
    final data = await _client.post('/foods', body: food.toJson());
    return FoodItemModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<FoodItemModel> updateFood(FoodItemModel food) async {
    final data = await _client.put('/foods/${food.id}', body: food.toJson());
    return FoodItemModel.fromJson(data as Map<String, dynamic>);
  }

  @override
  Future<void> deleteFood(String id) => _client.delete('/foods/$id');
}

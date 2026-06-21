// ignore_for_file: avoid_print
// One-off: exercises the app's real networking stack against the live mock_api.
//   dart run tool/api_smoke.dart
import 'package:resto/core/network/api_client.dart';
import 'package:resto/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:resto/features/menu/data/models/food_item_model.dart';

Future<void> main() async {
  final source =
      HttpMenuRemoteDataSource(ApiClient(baseUrl: 'http://localhost:8080'));

  final categories = await source.getCategories();
  print('GET /categories -> ${categories.map((c) => c.name).join(' / ')}');

  final pizza = await source.getFoods(categoryId: 'pizza');
  print('GET /foods?category_id=pizza -> '
      '${pizza.map((f) => '${f.name} (${f.price})').join(', ')}');

  const created = FoodItemModel(
    id: 'smoke1',
    name: 'خواردنی تاقیکردنەوە',
    description: 'لە سکریپتەوە',
    imageUrl: '',
    price: 4242,
    categoryId: 'pizza',
  );
  final saved = await source.createFood(created);
  print('POST /foods -> saved "${saved.name}" with price ${saved.price}');

  await source.deleteFood('smoke1');
  print('DELETE /foods/smoke1 -> ok');
}

import 'dart:convert';

import 'package:flutter_test/flutter_test.dart';
import 'package:http/http.dart' as http;
import 'package:http/testing.dart';
import 'package:resto/core/network/api_client.dart';
import 'package:resto/features/menu/data/datasources/menu_remote_data_source.dart';
import 'package:resto/features/menu/data/models/food_item_model.dart';

void main() {
  group('HttpMenuRemoteDataSource', () {
    test('getFoods hits /foods and parses the list', () async {
      late Uri requested;
      final source = HttpMenuRemoteDataSource(
        ApiClient(
          baseUrl: 'http://api.test',
          client: MockClient((request) async {
            requested = request.url;
            return http.Response(
              jsonEncode([
                {
                  'id': 'f1',
                  'name': 'پیتزا',
                  'description': 'd',
                  'image_url': 'http://img',
                  'price': 12000,
                  'category_id': 'pizza',
                }
              ]),
              200,
              headers: {'content-type': 'application/json; charset=utf-8'},
            );
          }),
        ),
      );

      final foods = await source.getFoods(categoryId: 'pizza');

      expect(requested.path, '/foods');
      expect(requested.queryParameters['category_id'], 'pizza');
      expect(foods.single.name, 'پیتزا');
      expect(foods.single.price, 12000);
    });

    test('createFood POSTs to /foods and returns the saved item', () async {
      late http.Request captured;
      final source = HttpMenuRemoteDataSource(
        ApiClient(
          baseUrl: 'http://api.test',
          client: MockClient((request) async {
            captured = request;
            return http.Response(request.body, 201,
                headers: {'content-type': 'application/json; charset=utf-8'});
          }),
        ),
      );

      const item = FoodItemModel(
        id: 'new',
        name: 'خواردنی نوێ',
        description: 'd',
        imageUrl: '',
        price: 5000,
        categoryId: 'pizza',
      );
      final saved = await source.createFood(item);

      expect(captured.method, 'POST');
      expect(captured.url.path, '/foods');
      expect(saved.id, 'new');
      expect(saved.name, 'خواردنی نوێ');
    });

    test('deleteFood issues a DELETE to /foods/<id>', () async {
      late http.Request captured;
      final source = HttpMenuRemoteDataSource(
        ApiClient(
          baseUrl: 'http://api.test',
          client: MockClient((request) async {
            captured = request;
            return http.Response('', 204);
          }),
        ),
      );

      await source.deleteFood('f1');

      expect(captured.method, 'DELETE');
      expect(captured.url.path, '/foods/f1');
    });
  });
}

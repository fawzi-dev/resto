import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:resto/core/localization/app_strings.dart';
import 'package:resto/features/menu/domain/entities/food_category.dart';
import 'package:resto/features/menu/domain/entities/food_item.dart';
import 'package:resto/features/menu/domain/repositories/menu_repository.dart';
import 'package:resto/features/menu/presentation/screens/menu_screen.dart';
import 'package:resto/features/menu/presentation/view_models/menu_view_model.dart';

class _FakeRepository implements MenuRepository {
  @override
  Future<List<FoodCategory>> fetchCategories() async => const [
        FoodCategory(id: 'pizza', name: 'پیتزا', icon: CategoryIcon.pizza),
      ];

  @override
  Future<List<FoodItem>> fetchFoods({String? categoryId}) async => const [
        FoodItem(
          id: 'f1',
          name: 'پیتزای مارگاریتا',
          description: 'پەنیر',
          imageUrl: '',
          price: 12000,
          categoryId: 'pizza',
        ),
      ];

  @override
  Future<FoodCategory> createCategory(FoodCategory category) async => category;

  @override
  Future<FoodItem> createFood(FoodItem food) async => food;

  @override
  Future<FoodItem> updateFood(FoodItem food) async => food;

  @override
  Future<void> deleteFood(String id) async {}
}

Widget _wrap(MenuViewModel vm) {
  return ChangeNotifierProvider<MenuViewModel>.value(
    value: vm,
    child: const MaterialApp(
      locale: Locale('ar'),
      home: Directionality(
        textDirection: TextDirection.rtl,
        child: MenuScreen(),
      ),
    ),
  );
}

void main() {
  testWidgets('renders the header title and quick actions', (tester) async {
    final vm = MenuViewModel(_FakeRepository());
    await tester.pumpWidget(_wrap(vm));

    expect(find.text(AppStrings.appTitle), findsOneWidget);
    expect(find.text(AppStrings.addFood), findsOneWidget);
    expect(find.text(AppStrings.addSection), findsOneWidget);
  });

  testWidgets('shows loaded food items after a successful load',
      (tester) async {
    final vm = MenuViewModel(_FakeRepository());
    await vm.load();

    await tester.pumpWidget(_wrap(vm));
    await tester.pump(const Duration(milliseconds: 400));

    expect(find.text('پیتزای مارگاریتا'), findsOneWidget);
    expect(find.text(AppStrings.foodsTitle), findsOneWidget);
  });
}

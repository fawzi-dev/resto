import 'package:flutter_test/flutter_test.dart';
import 'package:resto/core/network/failure.dart';
import 'package:resto/features/menu/domain/entities/food_category.dart';
import 'package:resto/features/menu/domain/entities/food_item.dart';
import 'package:resto/features/menu/domain/repositories/menu_repository.dart';
import 'package:resto/features/menu/presentation/view_models/menu_view_model.dart';

class _FakeRepository implements MenuRepository {
  _FakeRepository({this.failReads = false, this.failWrites = false});

  final bool failReads;
  final bool failWrites;

  static const _categories = [
    FoodCategory(id: 'pizza', name: 'پیتزا', icon: CategoryIcon.pizza),
    FoodCategory(id: 'burger', name: 'بەرگر', icon: CategoryIcon.burger),
  ];

  static const _foods = [
    FoodItem(id: 'f1', name: 'پیتزای مارگاریتا', description: 'پەنیر و باسیل', imageUrl: '', price: 12000, categoryId: 'pizza'),
    FoodItem(id: 'f2', name: 'بەرگری گۆشت', description: 'دبل پەنیر', imageUrl: '', price: 9000, categoryId: 'burger'),
    FoodItem(id: 'f3', name: 'پیتزای پەپەرۆنی', description: 'پەپەرۆنی', imageUrl: '', price: 13000, categoryId: 'pizza'),
  ];

  @override
  Future<List<FoodCategory>> fetchCategories() async {
    if (failReads) throw const NetworkFailure();
    return _categories;
  }

  @override
  Future<List<FoodItem>> fetchFoods({String? categoryId}) async {
    if (failReads) throw const NetworkFailure();
    return _foods;
  }

  @override
  Future<FoodCategory> createCategory(FoodCategory category) async {
    if (failWrites) throw const ServerFailure();
    return category;
  }

  @override
  Future<FoodItem> createFood(FoodItem food) async {
    if (failWrites) throw const ServerFailure();
    return food;
  }

  @override
  Future<FoodItem> updateFood(FoodItem food) async {
    if (failWrites) throw const ServerFailure();
    return food;
  }

  @override
  Future<void> deleteFood(String id) async {
    if (failWrites) throw const ServerFailure();
  }
}

FoodItem _newItem(String id, String name, String categoryId) => FoodItem(
      id: id,
      name: name,
      description: '',
      imageUrl: '',
      price: 1000,
      categoryId: categoryId,
    );

void main() {
  group('MenuViewModel reads', () {
    test('starts in the loading state', () {
      expect(MenuViewModel(_FakeRepository()).status, MenuStatus.loading);
    });

    test('load() populates categories (with All) and foods', () async {
      final vm = MenuViewModel(_FakeRepository());
      await vm.load();

      expect(vm.status, MenuStatus.success);
      expect(vm.categories.first.isAll, isTrue);
      expect(vm.categories.length, 3);
      expect(vm.visibleFoods.length, 3);
    });

    test('load() surfaces failures as the error state', () async {
      final vm = MenuViewModel(_FakeRepository(failReads: true));
      await vm.load();

      expect(vm.status, MenuStatus.error);
      expect(vm.errorMessage, isNotEmpty);
    });

    test('selectCategory filters the visible foods', () async {
      final vm = MenuViewModel(_FakeRepository());
      await vm.load();

      vm.selectCategory('pizza');
      expect(vm.visibleFoods.length, 2);

      vm.selectCategory(FoodCategory.all.id);
      expect(vm.visibleFoods.length, 3);
    });

    test('search matches name and description', () async {
      final vm = MenuViewModel(_FakeRepository());
      await vm.load();

      vm.search('پەپەرۆنی');
      expect(vm.visibleFoods.single.id, 'f3');
    });

    test('search and category filter combine (AND)', () async {
      final vm = MenuViewModel(_FakeRepository());
      await vm.load();

      vm.selectCategory('burger');
      vm.search('پیتزا');
      expect(vm.visibleFoods, isEmpty);
    });
  });

  group('MenuViewModel writes', () {
    test('addFood prepends and returns true on success', () async {
      final vm = MenuViewModel(_FakeRepository());
      await vm.load();

      final ok = await vm.addFood(_newItem('new', 'خواردنی نوێ', 'pizza'));
      expect(ok, isTrue);
      expect(vm.visibleFoods.first.id, 'new');
      expect(vm.visibleFoods.length, 4);
    });

    test('addFood rolls back and returns false when the API fails', () async {
      final vm = MenuViewModel(_FakeRepository(failWrites: true));
      await vm.load();

      final ok = await vm.addFood(_newItem('new', 'خواردنی نوێ', 'pizza'));
      expect(ok, isFalse);
      expect(vm.visibleFoods.any((f) => f.id == 'new'), isFalse);
      expect(vm.visibleFoods.length, 3);
    });

    test('updateFood replaces the matching item', () async {
      final vm = MenuViewModel(_FakeRepository());
      await vm.load();

      await vm.updateFood(_newItem('f1', 'ناوی نوێ', 'pizza'));
      expect(vm.visibleFoods.firstWhere((f) => f.id == 'f1').name, 'ناوی نوێ');
      expect(vm.visibleFoods.length, 3);
    });

    test('deleteFood removes and undoDelete restores its position', () async {
      final vm = MenuViewModel(_FakeRepository());
      await vm.load();

      await vm.deleteFood('f2');
      expect(vm.visibleFoods.map((f) => f.id), ['f1', 'f3']);

      await vm.undoDelete();
      expect(vm.visibleFoods.map((f) => f.id), ['f1', 'f2', 'f3']);
    });

    test('deleteFood rolls back when the API fails', () async {
      final vm = MenuViewModel(_FakeRepository(failWrites: true));
      await vm.load();

      final ok = await vm.deleteFood('f2');
      expect(ok, isFalse);
      expect(vm.visibleFoods.map((f) => f.id), ['f1', 'f2', 'f3']);
    });

    test('addCategory appends a section after All', () async {
      final vm = MenuViewModel(_FakeRepository());
      await vm.load();

      await vm.addCategory(
        const FoodCategory(id: 'salad', name: 'زەڵاتە', icon: CategoryIcon.salad),
      );
      expect(vm.categories.last.id, 'salad');
      expect(vm.categories.first.isAll, isTrue);
    });
  });
}

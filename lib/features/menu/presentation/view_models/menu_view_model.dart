import 'package:flutter/foundation.dart';

import '../../../../core/network/failure.dart';
import '../../domain/entities/food_category.dart';
import '../../domain/entities/food_item.dart';
import '../../domain/repositories/menu_repository.dart';

enum MenuStatus { loading, success, error }

class _RemovedFood {
  const _RemovedFood(this.item, this.index);
  final FoodItem item;
  final int index;
}

class MenuViewModel extends ChangeNotifier {
  MenuViewModel(this._repository);

  final MenuRepository _repository;

  MenuStatus _status = MenuStatus.loading;
  String _errorMessage = '';
  List<FoodCategory> _categories = const [];
  List<FoodItem> _allFoods = const [];
  String _selectedCategoryId = FoodCategory.all.id;
  String _query = '';
  _RemovedFood? _lastRemoved;

  MenuStatus get status => _status;
  String get errorMessage => _errorMessage;
  String get query => _query;
  String get selectedCategoryId => _selectedCategoryId;
  bool get isSearching => _query.trim().isNotEmpty;

  List<FoodCategory> get categories => [FoodCategory.all, ..._categories];

  List<FoodItem> get visibleFoods {
    final q = _query.trim().toLowerCase();
    return _allFoods.where((food) {
      final matchesCategory = _selectedCategoryId == FoodCategory.all.id ||
          food.categoryId == _selectedCategoryId;
      final matchesQuery = q.isEmpty ||
          food.name.toLowerCase().contains(q) ||
          food.description.toLowerCase().contains(q);
      return matchesCategory && matchesQuery;
    }).toList(growable: false);
  }

  Future<void> load() async {
    _status = MenuStatus.loading;
    notifyListeners();
    try {
      final results = await Future.wait([
        _repository.fetchCategories(),
        _repository.fetchFoods(),
      ]);
      _categories = results[0] as List<FoodCategory>;
      _allFoods = results[1] as List<FoodItem>;
      _status = MenuStatus.success;
    } on Failure catch (failure) {
      _errorMessage = failure.message;
      _status = MenuStatus.error;
    }
    notifyListeners();
  }

  void selectCategory(String categoryId) {
    if (_selectedCategoryId == categoryId) return;
    _selectedCategoryId = categoryId;
    notifyListeners();
  }

  void search(String value) {
    if (_query == value) return;
    _query = value;
    notifyListeners();
  }

  // Writes update the list right away, call the API, then reconcile or roll
  // back. The UI awaits the returned bool to surface a failure if one happens.
  Future<bool> addFood(FoodItem item) async {
    _allFoods = [item, ..._allFoods];
    notifyListeners();
    try {
      final saved = await _repository.createFood(item);
      _replaceFood(item.id, saved);
      return true;
    } on Failure {
      _allFoods = _allFoods.where((f) => f.id != item.id).toList();
      notifyListeners();
      return false;
    }
  }

  Future<bool> updateFood(FoodItem updated) async {
    final index = _allFoods.indexWhere((f) => f.id == updated.id);
    if (index == -1) return false;
    final previous = _allFoods[index];
    _replaceFood(updated.id, updated);
    try {
      final saved = await _repository.updateFood(updated);
      _replaceFood(updated.id, saved);
      return true;
    } on Failure {
      _replaceFood(updated.id, previous);
      return false;
    }
  }

  Future<bool> addCategory(FoodCategory category) async {
    _categories = [..._categories, category];
    notifyListeners();
    try {
      await _repository.createCategory(category);
      return true;
    } on Failure {
      _categories = _categories.where((c) => c.id != category.id).toList();
      notifyListeners();
      return false;
    }
  }

  Future<bool> deleteFood(String id) async {
    final index = _allFoods.indexWhere((f) => f.id == id);
    if (index == -1) return false;
    final removed = _RemovedFood(_allFoods[index], index);
    _allFoods = [..._allFoods]..removeAt(index);
    notifyListeners();
    try {
      await _repository.deleteFood(id);
      _lastRemoved = removed;
      return true;
    } on Failure {
      _allFoods = [..._allFoods]..insert(removed.index, removed.item);
      notifyListeners();
      return false;
    }
  }

  Future<bool> undoDelete() async {
    final removed = _lastRemoved;
    if (removed == null) return false;
    final index = removed.index.clamp(0, _allFoods.length);
    _allFoods = [..._allFoods]..insert(index, removed.item);
    _lastRemoved = null;
    notifyListeners();
    try {
      await _repository.createFood(removed.item);
      return true;
    } on Failure {
      _allFoods = _allFoods.where((f) => f.id != removed.item.id).toList();
      notifyListeners();
      return false;
    }
  }

  void _replaceFood(String id, FoodItem replacement) {
    final index = _allFoods.indexWhere((f) => f.id == id);
    if (index == -1) return;
    _allFoods = [..._allFoods]..[index] = replacement;
    notifyListeners();
  }
}

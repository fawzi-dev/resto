/// In-memory data store for the mock API. Seeded with the same menu the app
/// ships as an offline fallback, then mutated by the CRUD endpoints.
class MenuStore {
  final List<Map<String, dynamic>> _categories = [
    {'id': 'pizza', 'name': 'پیتزا', 'icon': 'pizza'},
    {'id': 'burger', 'name': 'بەرگر', 'icon': 'burger'},
    {'id': 'shawarma', 'name': 'شاورمە', 'icon': 'shawarma'},
    {'id': 'salad', 'name': 'زەڵاتە', 'icon': 'salad'},
    {'id': 'drinks', 'name': 'خواردنەوە', 'icon': 'drink'},
    {'id': 'dessert', 'name': 'شیرینی', 'icon': 'dessert'},
  ];

  final List<Map<String, dynamic>> _foods = [
    _food('f1', 'شاورمەی گۆشت', 'شاورمەی گۆشتی تازە لەگەڵ سۆس و سەوزە', '1561758033-d89a9ad46330', 8000, 'shawarma'),
    _food('f2', 'بەرگر دبل پەنیر', 'بەرگری تایبەت و دبل پەنیر', '1568901346375-23c9450c58cd', 9500, 'burger'),
    _food('f3', 'زەڵاتەی ئەمریکی', 'زەڵاتەی تازە لەگەڵ سۆسی تایبەت', '1512621776951-a57141f2eefd', 5000, 'salad'),
    _food('f4', 'پیتزای مارگاریتا', 'پیتزا لەگەڵ پەنیری مۆزارێلا و باسیل', '1513104890138-7c749659a591', 12000, 'pizza'),
    _food('f5', 'پیتزای پەپەرۆنی', 'پیتزا لەگەڵ پەپەرۆنی و پەنیری زۆر', '1565299624946-b28f40a0ae38', 13000, 'pizza'),
    _food('f6', 'بەرگری مریشک', 'بەرگری مریشکی برژاو لەگەڵ سۆسی تایبەت', '1606755962773-d324e0a13086', 8500, 'burger'),
    _food('f7', 'شاورمەی مریشک', 'شاورمەی مریشک لەگەڵ سیر و ترشی', '1559847844-5315695dadae', 7000, 'shawarma'),
    _food('f8', 'زەڵاتەی سیزەر', 'زەڵاتەی سیزەر لەگەڵ مریشک و پەنیری پارمیزان', '1550304943-4f24f54ddde9', 6500, 'salad'),
    _food('f9', 'شەربەتی پرتەقاڵ', 'شەربەتی پرتەقاڵی سروشتی و تازە', '1613478223719-2ab802602423', 3000, 'drinks'),
    _food('f10', 'مۆیتۆی لیمۆ', 'خواردنەوەیەکی ساردی تازەکەرەوە', '1437418747212-8d9709afab22', 4000, 'drinks'),
    _food('f11', 'کێکی شکۆلاتە', 'کێکی شکۆلاتەی گەرم لەگەڵ ئایس کرێم', '1578985545062-69928b1d9587', 5500, 'dessert'),
    _food('f12', 'چیز کێک', 'چیز کێکی نیویۆرکی لەگەڵ فڕاولە', '1533134242443-d4fd215305ad', 6000, 'dessert'),
  ];

  static Map<String, dynamic> _food(
    String id,
    String name,
    String description,
    String photoId,
    int price,
    String categoryId,
  ) {
    return {
      'id': id,
      'name': name,
      'description': description,
      'image_url':
          'https://images.unsplash.com/photo-$photoId?auto=format&fit=crop&w=500&q=70',
      'price': price,
      'category_id': categoryId,
    };
  }

  List<Map<String, dynamic>> categories() => List.unmodifiable(_categories);

  List<Map<String, dynamic>> foods({String? categoryId}) {
    if (categoryId == null) return List.unmodifiable(_foods);
    return _foods.where((f) => f['category_id'] == categoryId).toList();
  }

  Map<String, dynamic> addCategory(Map<String, dynamic> body) {
    final category = {
      'id': body['id'] ?? 'cat_${DateTime.now().millisecondsSinceEpoch}',
      'name': body['name'],
      'icon': body['icon'] ?? 'other',
    };
    _categories.add(category);
    return category;
  }

  Map<String, dynamic> addFood(Map<String, dynamic> body) {
    final food = {
      'id': body['id'] ?? 'food_${DateTime.now().millisecondsSinceEpoch}',
      'name': body['name'],
      'description': body['description'] ?? '',
      'image_url': body['image_url'] ?? '',
      'price': body['price'] ?? 0,
      'category_id': body['category_id'],
    };
    _foods.insert(0, food);
    return food;
  }

  Map<String, dynamic>? updateFood(String id, Map<String, dynamic> body) {
    final index = _foods.indexWhere((f) => f['id'] == id);
    if (index == -1) return null;
    final updated = {..._foods[index], ...body, 'id': id};
    _foods[index] = updated;
    return updated;
  }

  bool deleteFood(String id) {
    final index = _foods.indexWhere((f) => f['id'] == id);
    if (index == -1) return false;
    _foods.removeAt(index);
    return true;
  }
}

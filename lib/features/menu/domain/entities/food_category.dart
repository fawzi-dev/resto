enum CategoryIcon { all, pizza, burger, shawarma, salad, drink, dessert, other }

class FoodCategory {
  const FoodCategory({required this.id, required this.name, this.icon = CategoryIcon.other});

  final String id;
  final String name;
  final CategoryIcon icon;

  // The "All" filter isn't a real section, just a way to clear the filter.
  static const FoodCategory all = FoodCategory(id: '_all', name: 'all', icon: CategoryIcon.all);

  bool get isAll => id == all.id;

  FoodCategory copyWith({String? id, String? name, CategoryIcon? icon}) {
    return FoodCategory(id: id ?? this.id, name: name ?? this.name, icon: icon ?? this.icon);
  }

  @override
  bool operator ==(Object other) => identical(this, other) || other is FoodCategory && other.id == id && other.name == name && other.icon == icon;

  @override
  int get hashCode => Object.hash(id, name, icon);
}

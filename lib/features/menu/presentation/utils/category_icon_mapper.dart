import 'package:flutter/material.dart';

import '../../domain/entities/food_category.dart';

extension CategoryIconMapper on CategoryIcon {
  IconData get iconData => switch (this) {
        CategoryIcon.all => Icons.local_pizza_rounded,
        CategoryIcon.pizza => Icons.local_pizza_rounded,
        CategoryIcon.burger => Icons.lunch_dining_rounded,
        CategoryIcon.shawarma => Icons.kebab_dining_rounded,
        CategoryIcon.salad => Icons.eco_rounded,
        CategoryIcon.drink => Icons.local_cafe_rounded,
        CategoryIcon.dessert => Icons.icecream_rounded,
        CategoryIcon.other => Icons.restaurant_rounded,
      };
}

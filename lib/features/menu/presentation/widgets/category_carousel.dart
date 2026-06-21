import 'package:flutter/material.dart';

import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/food_category.dart';
import 'category_chip.dart';

class CategoryCarousel extends StatelessWidget {
  const CategoryCarousel({
    super.key,
    required this.categories,
    required this.selectedId,
    required this.onSelected,
  });

  final List<FoodCategory> categories;
  final String selectedId;
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        physics: const BouncingScrollPhysics(),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.screenPadding,
        ),
        itemCount: categories.length,
        separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm + 2),
        itemBuilder: (context, index) {
          final category = categories[index];
          final display = category.isAll
              ? category.copyWith(name: AppStrings.all)
              : category;
          return CategoryChip(
            category: display,
            selected: category.id == selectedId,
            onTap: () => onSelected(category.id),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../domain/entities/food_category.dart';
import '../utils/category_icon_mapper.dart';

class CategoryChip extends StatelessWidget {
  const CategoryChip({
    super.key,
    required this.category,
    required this.selected,
    required this.onTap,
  });

  final FoodCategory category;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final foreground = selected ? AppColors.textOnPrimary : AppColors.textDark;
    return GestureDetector(
      onTap: onTap,
      behavior: HitTestBehavior.opaque,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.lg,
          vertical: AppSpacing.sm + 2,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.surface,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
          boxShadow: selected
              ? const [
                  BoxShadow(
                    color: Color(0x332ECC71),
                    blurRadius: 14,
                    offset: Offset(0, 6),
                  ),
                ]
              : null,
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(category.icon.iconData, size: 18, color: foreground),
            const SizedBox(width: AppSpacing.sm),
            Text(
              category.name,
              style: AppTypography.chip.copyWith(color: foreground),
            ),
          ],
        ),
      ),
    );
  }
}

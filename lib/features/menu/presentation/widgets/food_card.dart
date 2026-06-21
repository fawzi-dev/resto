import 'package:flutter/material.dart';

import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/currency_formatter.dart';
import '../../../../core/widgets/app_network_image.dart';
import '../../domain/entities/food_item.dart';

class FoodCard extends StatelessWidget {
  const FoodCard({
    super.key,
    required this.item,
    required this.onEdit,
    required this.onDelete,
  });

  final FoodItem item;
  final VoidCallback onEdit;
  final VoidCallback onDelete;

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
        boxShadow: const [
          BoxShadow(
            color: AppColors.shadow,
            blurRadius: 18,
            offset: Offset(0, 10),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          ClipRRect(
            borderRadius: const BorderRadius.vertical(
              top: Radius.circular(AppRadius.lg),
            ),
            child: AspectRatio(
              aspectRatio: 4 / 3,
              child: AppNetworkImage(url: item.imageUrl),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  item.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.cardTitle,
                ),
                const SizedBox(height: AppSpacing.xs),
                Text(
                  item.description,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                  style: AppTypography.body,
                ),
                const SizedBox(height: AppSpacing.md),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        CurrencyFormatter.format(item.price),
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: AppTypography.price,
                      ),
                    ),
                    _CardIconButton(
                      icon: Icons.edit_outlined,
                      color: AppColors.primaryDark,
                      background: AppColors.primarySurface,
                      tooltip: AppStrings.edit,
                      onTap: onEdit,
                    ),
                    const SizedBox(width: AppSpacing.sm),
                    _CardIconButton(
                      icon: Icons.delete_outline_rounded,
                      color: AppColors.danger,
                      background: AppColors.dangerSurface,
                      tooltip: AppStrings.delete,
                      onTap: onDelete,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _CardIconButton extends StatelessWidget {
  const _CardIconButton({
    required this.icon,
    required this.color,
    required this.background,
    required this.tooltip,
    required this.onTap,
  });

  final IconData icon;
  final Color color;
  final Color background;
  final String tooltip;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: background,
      borderRadius: BorderRadius.circular(AppRadius.sm),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.sm),
        child: Tooltip(
          message: tooltip,
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.sm - 1),
            child: Icon(icon, size: 18, color: color),
          ),
        ),
      ),
    );
  }
}

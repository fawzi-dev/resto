import 'package:flutter/material.dart';

import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({
    super.key,
    required this.onAddFood,
    required this.onAddSection,
  });

  final VoidCallback onAddFood;
  final VoidCallback onAddSection;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _ActionButton(
            label: AppStrings.addFood,
            onTap: onAddFood,
            filled: true,
          ),
        ),
        const SizedBox(width: AppSpacing.md),
        Expanded(
          child: _ActionButton(
            label: AppStrings.addSection,
            onTap: onAddSection,
            filled: false,
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.label,
    required this.onTap,
    required this.filled,
  });

  final String label;
  final VoidCallback onTap;
  final bool filled;

  @override
  Widget build(BuildContext context) {
    final foreground = filled ? AppColors.textOnPrimary : AppColors.primaryDark;
    return DecoratedBox(
      decoration: BoxDecoration(
        gradient: filled ? AppColors.primaryGradient : null,
        color: filled ? null : AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.md),
        border: filled ? null : Border.all(color: AppColors.primary, width: 1.4),
        boxShadow: filled
            ? const [
                BoxShadow(
                  color: Color(0x332ECC71),
                  blurRadius: 16,
                  offset: Offset(0, 8),
                ),
              ]
            : null,
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          onTap: onTap,
          borderRadius: BorderRadius.circular(AppRadius.md),
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: AppSpacing.md + 2),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Flexible(
                  child: Text(
                    label,
                    overflow: TextOverflow.ellipsis,
                    style: AppTypography.button.copyWith(color: foreground),
                  ),
                ),
                const SizedBox(width: AppSpacing.sm),
                Icon(Icons.add_rounded, size: 20, color: foreground),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

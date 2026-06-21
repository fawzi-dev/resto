import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

// Shared placeholder for the empty, no-results and error screens.
class InfoState extends StatelessWidget {
  const InfoState({
    super.key,
    required this.icon,
    required this.title,
    required this.message,
    this.actionLabel,
    this.onAction,
    this.iconColor = AppColors.primary,
    this.iconBackground = AppColors.primarySurface,
  });

  final IconData icon;
  final String title;
  final String message;
  final String? actionLabel;
  final VoidCallback? onAction;
  final Color iconColor;
  final Color iconBackground;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xxl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 88,
              height: 88,
              decoration: BoxDecoration(
                color: iconBackground,
                shape: BoxShape.circle,
              ),
              child: Icon(icon, size: 40, color: iconColor),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              title,
              textAlign: TextAlign.center,
              style: AppTypography.sectionTitle,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              textAlign: TextAlign.center,
              style: AppTypography.body,
            ),
            if (actionLabel != null && onAction != null) ...[
              const SizedBox(height: AppSpacing.xl),
              FilledButton(
                onPressed: onAction,
                style: FilledButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: AppColors.textOnPrimary,
                  textStyle: AppTypography.button,
                  padding: const EdgeInsets.symmetric(
                    horizontal: AppSpacing.xxl,
                    vertical: AppSpacing.md,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(AppRadius.md),
                  ),
                ),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

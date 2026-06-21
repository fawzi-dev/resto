import 'package:flutter/material.dart';

import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

Future<bool> showDeleteConfirmationDialog(BuildContext context) async {
  final result = await showDialog<bool>(
    context: context,
    builder: (context) => const _ConfirmDeleteDialog(),
  );
  return result ?? false;
}

class _ConfirmDeleteDialog extends StatelessWidget {
  const _ConfirmDeleteDialog();

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(AppSpacing.xxl),
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.xl),
      ),
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 64,
              height: 64,
              decoration: const BoxDecoration(
                color: AppColors.dangerSurface,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.delete_outline_rounded,
                color: AppColors.danger,
                size: 30,
              ),
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              AppStrings.deleteTitle,
              textAlign: TextAlign.center,
              style: AppTypography.sectionTitle,
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              AppStrings.deleteMessage,
              textAlign: TextAlign.center,
              style: AppTypography.body,
            ),
            const SizedBox(height: AppSpacing.xl),
            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: () => Navigator.of(context).pop(false),
                    style: OutlinedButton.styleFrom(
                      foregroundColor: AppColors.textDark,
                      side: const BorderSide(color: AppColors.border),
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      textStyle: AppTypography.button,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    child: const Text(AppStrings.cancel),
                  ),
                ),
                const SizedBox(width: AppSpacing.md),
                Expanded(
                  child: FilledButton(
                    onPressed: () => Navigator.of(context).pop(true),
                    style: FilledButton.styleFrom(
                      backgroundColor: AppColors.danger,
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(
                        vertical: AppSpacing.md,
                      ),
                      textStyle: AppTypography.button,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(AppRadius.md),
                      ),
                    ),
                    child: const Text(AppStrings.confirm),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

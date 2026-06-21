import 'package:flutter/material.dart';

import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

// Shared chrome for the create sheets: title, scrollable body that dodges the
// keyboard, and a pinned save button.
class SheetScaffold extends StatelessWidget {
  const SheetScaffold({
    super.key,
    required this.title,
    required this.child,
    required this.onSubmit,
  });

  final String title;
  final Widget child;
  final VoidCallback onSubmit;

  @override
  Widget build(BuildContext context) {
    final bottomInset = MediaQuery.viewInsetsOf(context).bottom;
    return Padding(
      padding: EdgeInsets.only(bottom: bottomInset),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.xs,
                AppSpacing.xl,
                AppSpacing.lg,
              ),
              child: Text(title, style: AppTypography.sectionTitle),
            ),
            Flexible(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: AppSpacing.xl),
                child: child,
              ),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.xl,
                AppSpacing.lg,
                AppSpacing.xl,
                AppSpacing.lg,
              ),
              child: SizedBox(
                width: double.infinity,
                child: FilledButton(
                  onPressed: onSubmit,
                  style: FilledButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: AppColors.textOnPrimary,
                    textStyle: AppTypography.button,
                    padding: const EdgeInsets.symmetric(
                      vertical: AppSpacing.md + 2,
                    ),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(AppRadius.md),
                    ),
                  ),
                  child: const Text(AppStrings.save),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

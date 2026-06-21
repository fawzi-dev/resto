import 'package:flutter/material.dart';

import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class MenuHeader extends StatelessWidget {
  const MenuHeader({
    super.key,
    this.onNotificationsTap,
    this.onOrdersTap,
    this.hasNotifications = true,
  });

  final VoidCallback? onNotificationsTap;
  final VoidCallback? onOrdersTap;
  final bool hasNotifications;

  @override
  Widget build(BuildContext context) {
    // In RTL the first child lands on the right, so bag = right, bell = left.
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: AppSpacing.screenPadding,
        vertical: AppSpacing.sm,
      ),
      child: Row(
        children: [
          _HeaderIconButton(
            icon: Icons.shopping_bag_outlined,
            onTap: onOrdersTap,
          ),
          Expanded(
            child: Text(
              AppStrings.appTitle,
              textAlign: TextAlign.center,
              style: AppTypography.headline,
            ),
          ),
          _HeaderIconButton(
            icon: Icons.notifications_none_rounded,
            showBadge: hasNotifications,
            onTap: onNotificationsTap,
          ),
        ],
      ),
    );
  }
}

class _HeaderIconButton extends StatelessWidget {
  const _HeaderIconButton({
    required this.icon,
    this.onTap,
    this.showBadge = false,
  });

  final IconData icon;
  final VoidCallback? onTap;
  final bool showBadge;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.surface,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(AppRadius.md),
        side: const BorderSide(color: AppColors.border),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.md),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm + 1),
          child: Stack(
            clipBehavior: Clip.none,
            children: [
              Icon(icon, size: 22, color: AppColors.textDark),
              if (showBadge)
                Positioned(
                  top: -1,
                  right: -1,
                  child: Container(
                    width: 9,
                    height: 9,
                    decoration: BoxDecoration(
                      color: AppColors.primary,
                      shape: BoxShape.circle,
                      border: Border.all(color: AppColors.surface, width: 1.5),
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

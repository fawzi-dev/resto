import 'package:flutter/material.dart';

import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/shimmer_box.dart';
import 'food_grid.dart';

// Loading placeholder that mirrors the real layout, so nothing jumps around
// when the data arrives.
class MenuSkeleton extends StatelessWidget {
  const MenuSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        SizedBox(
          height: 40,
          child: ListView.separated(
            scrollDirection: Axis.horizontal,
            physics: const NeverScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.screenPadding,
            ),
            itemCount: 5,
            separatorBuilder: (_, __) => const SizedBox(width: AppSpacing.sm),
            itemBuilder: (_, __) => const ShimmerBox(
              width: 92,
              borderRadius: BorderRadius.all(Radius.circular(AppRadius.md)),
            ),
          ),
        ),
        const SizedBox(height: AppSpacing.xl),
        const Padding(
          padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          child: Align(
            alignment: AlignmentDirectional.centerStart,
            child: ShimmerBox(width: 120, height: 18),
          ),
        ),
        const SizedBox(height: AppSpacing.lg),
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: AppSpacing.screenPadding,
          ),
          child: GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            itemCount: 6,
            gridDelegate: foodGridDelegate(context),
            itemBuilder: (_, __) => const _CardSkeleton(),
          ),
        ),
      ],
    );
  }
}

class _CardSkeleton extends StatelessWidget {
  const _CardSkeleton();

  @override
  Widget build(BuildContext context) {
    return DecoratedBox(
      decoration: BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.circular(AppRadius.lg),
        border: Border.all(color: AppColors.border),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const AspectRatio(
            aspectRatio: 4 / 3,
            child: ShimmerBox(
              borderRadius:
                  BorderRadius.vertical(top: Radius.circular(AppRadius.lg)),
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(AppSpacing.md),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: const [
                ShimmerBox(width: 110, height: 13),
                SizedBox(height: AppSpacing.sm),
                ShimmerBox(width: 140, height: 11),
                SizedBox(height: AppSpacing.md),
                ShimmerBox(width: 70, height: 13),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

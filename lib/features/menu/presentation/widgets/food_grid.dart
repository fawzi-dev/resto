import 'package:flutter/material.dart';

import '../../../../core/theme/app_spacing.dart';
import '../../../../core/widgets/fade_slide_in.dart';
import '../../domain/entities/food_item.dart';
import 'food_card.dart';

const double _crossSpacing = AppSpacing.md;
const double _mainSpacing = AppSpacing.lg;
const double _cardContentHeight = 114; // everything under the 4:3 image

// Derive the aspect ratio from the real width so cards never overflow on
// narrow screens. Shared with the loading skeleton so they line up exactly.
SliverGridDelegate foodGridDelegate(BuildContext context) {
  final width = MediaQuery.sizeOf(context).width - AppSpacing.screenPadding * 2;
  final itemWidth = (width - _crossSpacing) / 2;
  final itemHeight = itemWidth * 3 / 4 + _cardContentHeight;
  return SliverGridDelegateWithFixedCrossAxisCount(
    crossAxisCount: 2,
    crossAxisSpacing: _crossSpacing,
    mainAxisSpacing: _mainSpacing,
    childAspectRatio: itemWidth / itemHeight,
  );
}

class FoodGrid extends StatelessWidget {
  const FoodGrid({
    super.key,
    required this.items,
    required this.onEdit,
    required this.onDelete,
  });

  final List<FoodItem> items;
  final ValueChanged<FoodItem> onEdit;
  final ValueChanged<FoodItem> onDelete;

  @override
  Widget build(BuildContext context) {
    return SliverGrid(
      gridDelegate: foodGridDelegate(context),
      delegate: SliverChildBuilderDelegate(
        (context, index) {
          final item = items[index];
          return FadeSlideIn(
            delay: Duration(milliseconds: 35 * index.clamp(0, 8)),
            key: ValueKey(item.id),
            child: FoodCard(
              item: item,
              onEdit: () => onEdit(item),
              onDelete: () => onDelete(item),
            ),
          );
        },
        childCount: items.length,
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/food_category.dart';
import '../../domain/entities/food_item.dart';
import '../utils/category_icon_mapper.dart';
import 'sheet_scaffold.dart';

// Pass [initial] to edit an existing item; the result keeps the same id.
Future<FoodItem?> showFoodSheet(
  BuildContext context, {
  required List<FoodCategory> categories,
  FoodItem? initial,
}) {
  return showModalBottomSheet<FoodItem>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _AddFoodSheet(categories: categories, initial: initial),
  );
}

class _AddFoodSheet extends StatefulWidget {
  const _AddFoodSheet({required this.categories, this.initial});

  final List<FoodCategory> categories;
  final FoodItem? initial;

  @override
  State<_AddFoodSheet> createState() => _AddFoodSheetState();
}

class _AddFoodSheetState extends State<_AddFoodSheet> {
  static const String _defaultImage =
      'https://images.unsplash.com/photo-1504674900247-0877df9cc836'
      '?auto=format&fit=crop&w=500&q=70';

  final _formKey = GlobalKey<FormState>();
  late final _nameController =
      TextEditingController(text: widget.initial?.name);
  late final _descriptionController =
      TextEditingController(text: widget.initial?.description);
  late final _priceController = TextEditingController(
    text: widget.initial != null ? '${widget.initial!.price}' : null,
  );

  late FoodCategory _category = _resolveInitialCategory();

  FoodCategory _resolveInitialCategory() {
    final initialId = widget.initial?.categoryId;
    return widget.categories.firstWhere(
      (c) => c.id == initialId,
      orElse: () => widget.categories.first,
    );
  }

  @override
  void dispose() {
    _nameController.dispose();
    _descriptionController.dispose();
    _priceController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final initial = widget.initial;
    final item = FoodItem(
      id: initial?.id ?? IdGenerator.next('food'),
      name: _nameController.text.trim(),
      description: _descriptionController.text.trim(),
      imageUrl: initial?.imageUrl ?? _defaultImage,
      price: int.parse(_priceController.text.trim()),
      categoryId: _category.id,
    );
    Navigator.of(context).pop(item);
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: widget.initial == null
          ? AppStrings.newFoodTitle
          : AppStrings.editFoodTitle,
      onSubmit: _submit,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            AppTextField(
              label: AppStrings.fieldName,
              controller: _nameController,
              textInputAction: TextInputAction.next,
              validator: _required,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: AppStrings.fieldDescription,
              controller: _descriptionController,
              maxLines: 2,
              textInputAction: TextInputAction.next,
            ),
            const SizedBox(height: AppSpacing.lg),
            AppTextField(
              label: AppStrings.fieldPrice,
              controller: _priceController,
              keyboardType: TextInputType.number,
              suffixText: AppStrings.currency,
              validator: _validatePrice,
            ),
            const SizedBox(height: AppSpacing.lg),
            _CategoryPicker(
              categories: widget.categories,
              selected: _category,
              onSelected: (c) => setState(() => _category = c),
            ),
          ],
        ),
      ),
    );
  }

  String? _required(String? value) =>
      (value == null || value.trim().isEmpty) ? AppStrings.requiredField : null;

  String? _validatePrice(String? value) {
    if (value == null || value.trim().isEmpty) return AppStrings.requiredField;
    final parsed = int.tryParse(value.trim());
    if (parsed == null || parsed <= 0) return AppStrings.invalidPrice;
    return null;
  }
}

class _CategoryPicker extends StatelessWidget {
  const _CategoryPicker({
    required this.categories,
    required this.selected,
    required this.onSelected,
  });

  final List<FoodCategory> categories;
  final FoodCategory selected;
  final ValueChanged<FoodCategory> onSelected;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppStrings.fieldCategory,
          style: AppTypography.cardTitle.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.sm),
        Wrap(
          spacing: AppSpacing.sm,
          runSpacing: AppSpacing.sm,
          children: [
            for (final category in categories)
              _CategoryOption(
                category: category,
                selected: category.id == selected.id,
                onTap: () => onSelected(category),
              ),
          ],
        ),
      ],
    );
  }
}

class _CategoryOption extends StatelessWidget {
  const _CategoryOption({
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
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(category.icon.iconData, size: 16, color: foreground),
            const SizedBox(width: AppSpacing.xs + 2),
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

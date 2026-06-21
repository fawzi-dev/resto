import 'package:flutter/material.dart';

import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';
import '../../../../core/utils/id_generator.dart';
import '../../../../core/widgets/app_text_field.dart';
import '../../domain/entities/food_category.dart';
import '../utils/category_icon_mapper.dart';
import 'sheet_scaffold.dart';

Future<FoodCategory?> showAddSectionSheet(BuildContext context) {
  return showModalBottomSheet<FoodCategory>(
    context: context,
    isScrollControlled: true,
    builder: (_) => const _AddSectionSheet(),
  );
}

class _AddSectionSheet extends StatefulWidget {
  const _AddSectionSheet();

  @override
  State<_AddSectionSheet> createState() => _AddSectionSheetState();
}

class _AddSectionSheetState extends State<_AddSectionSheet> {
  static const List<CategoryIcon> _icons = [
    CategoryIcon.pizza,
    CategoryIcon.burger,
    CategoryIcon.shawarma,
    CategoryIcon.salad,
    CategoryIcon.drink,
    CategoryIcon.dessert,
    CategoryIcon.other,
  ];

  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  CategoryIcon _icon = CategoryIcon.pizza;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    final category = FoodCategory(
      id: IdGenerator.next('cat'),
      name: _nameController.text.trim(),
      icon: _icon,
    );
    Navigator.of(context).pop(category);
  }

  @override
  Widget build(BuildContext context) {
    return SheetScaffold(
      title: AppStrings.newSectionTitle,
      onSubmit: _submit,
      child: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AppTextField(
              label: AppStrings.fieldSectionName,
              controller: _nameController,
              textInputAction: TextInputAction.done,
              validator: (value) => (value == null || value.trim().isEmpty)
                  ? AppStrings.requiredField
                  : null,
            ),
            const SizedBox(height: AppSpacing.lg),
            Text(
              AppStrings.fieldCategory,
              style:
                  AppTypography.cardTitle.copyWith(fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: AppSpacing.md),
            Wrap(
              spacing: AppSpacing.md,
              runSpacing: AppSpacing.md,
              children: [
                for (final icon in _icons)
                  _IconOption(
                    icon: icon,
                    selected: icon == _icon,
                    onTap: () => setState(() => _icon = icon),
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _IconOption extends StatelessWidget {
  const _IconOption({
    required this.icon,
    required this.selected,
    required this.onTap,
  });

  final CategoryIcon icon;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 180),
        width: 52,
        height: 52,
        decoration: BoxDecoration(
          color: selected ? AppColors.primary : AppColors.background,
          borderRadius: BorderRadius.circular(AppRadius.md),
          border: Border.all(
            color: selected ? AppColors.primary : AppColors.border,
          ),
        ),
        child: Icon(
          icon.iconData,
          color: selected ? AppColors.textOnPrimary : AppColors.textDark,
          size: 24,
        ),
      ),
    );
  }
}

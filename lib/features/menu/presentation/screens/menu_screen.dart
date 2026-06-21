import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../domain/entities/food_item.dart';
import '../view_models/menu_view_model.dart';
import '../widgets/add_food_sheet.dart';
import '../widgets/add_section_sheet.dart';
import '../widgets/category_carousel.dart';
import '../widgets/confirm_delete_dialog.dart';
import '../widgets/food_grid.dart';
import '../widgets/info_state.dart';
import '../widgets/menu_header.dart';
import '../widgets/menu_search_bar.dart';
import '../widgets/menu_skeleton.dart';
import '../widgets/quick_actions.dart';
import '../widgets/section_header.dart';

class MenuScreen extends StatelessWidget {
  const MenuScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: SafeArea(
        child: Column(
          children: [
            MenuHeader(onNotificationsTap: () {}, onOrdersTap: () {}),
            const Expanded(child: _MenuBody()),
          ],
        ),
      ),
    );
  }
}

class _MenuBody extends StatelessWidget {
  const _MenuBody();

  @override
  Widget build(BuildContext context) {
    final menu = context.watch<MenuViewModel>();

    return CustomScrollView(
      physics: const BouncingScrollPhysics(),
      slivers: [
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.sm)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          sliver: SliverToBoxAdapter(child: MenuSearchBar(onChanged: menu.search)),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.lg)),
        SliverPadding(
          padding: const EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
          sliver: SliverToBoxAdapter(
            child: QuickActions(onAddFood: () => _onAddFood(context), onAddSection: () => _onAddSection(context)),
          ),
        ),
        const SliverToBoxAdapter(child: SizedBox(height: AppSpacing.xl)),
        ..._contentSlivers(context, menu),
      ],
    );
  }

  List<Widget> _contentSlivers(BuildContext context, MenuViewModel menu) {
    return switch (menu.status) {
      MenuStatus.loading => const [SliverToBoxAdapter(child: MenuSkeleton())],
      MenuStatus.error => [
        SliverFillRemaining(
          hasScrollBody: false,
          child: InfoState(
            icon: Icons.cloud_off_rounded,
            title: AppStrings.errorTitle,
            message: AppStrings.errorMessage,
            actionLabel: AppStrings.retry,
            onAction: () => context.read<MenuViewModel>().load(),
            iconColor: AppColors.danger,
            iconBackground: AppColors.dangerSurface,
          ),
        ),
      ],
      MenuStatus.success => _successSlivers(context, menu),
    };
  }

  List<Widget> _successSlivers(BuildContext context, MenuViewModel menu) {
    final foods = menu.visibleFoods;
    return [
      SliverToBoxAdapter(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              child: SectionHeader(title: AppStrings.sectionsTitle),
            ),
            const SizedBox(height: AppSpacing.md),
            CategoryCarousel(categories: menu.categories, selectedId: menu.selectedCategoryId, onSelected: menu.selectCategory),
            const SizedBox(height: AppSpacing.xl),
            const Padding(
              padding: EdgeInsets.symmetric(horizontal: AppSpacing.screenPadding),
              child: SectionHeader(title: AppStrings.foodsTitle),
            ),
            const SizedBox(height: AppSpacing.lg),
          ],
        ),
      ),
      if (foods.isEmpty)
        SliverFillRemaining(hasScrollBody: false, child: _emptyState(context, menu))
      else
        SliverPadding(
          padding: const EdgeInsets.fromLTRB(AppSpacing.screenPadding, 0, AppSpacing.screenPadding, AppSpacing.xl),
          sliver: FoodGrid(items: foods, onEdit: (item) => _onEditFood(context, item), onDelete: (item) => _onDeleteFood(context, item)),
        ),
    ];
  }

  Widget _emptyState(BuildContext context, MenuViewModel menu) {
    if (menu.isSearching) {
      return const InfoState(icon: Icons.search_off_rounded, title: AppStrings.searchEmptyTitle, message: AppStrings.searchEmptyMessage);
    }
    return InfoState(icon: Icons.restaurant_menu_rounded, title: AppStrings.emptyTitle, message: AppStrings.emptyMessage, actionLabel: AppStrings.addFood, onAction: () => _onAddFood(context));
  }

  Future<void> _onAddFood(BuildContext context) async {
    final menu = context.read<MenuViewModel>();
    final messenger = ScaffoldMessenger.of(context);
    final sections = menu.categories.where((c) => !c.isAll).toList(growable: false);

    if (sections.isEmpty) {
      messenger.showSnackBar(_snackBar(AppStrings.needSectionFirst));
      return;
    }

    final item = await showFoodSheet(context, categories: sections);
    if (item == null) return;
    final ok = await menu.addFood(item);
    messenger.showSnackBar(
      _snackBar(ok ? AppStrings.foodAddedToast : AppStrings.actionFailed),
    );
  }

  Future<void> _onEditFood(BuildContext context, FoodItem item) async {
    final menu = context.read<MenuViewModel>();
    final messenger = ScaffoldMessenger.of(context);
    final sections = menu.categories.where((c) => !c.isAll).toList(growable: false);

    final updated = await showFoodSheet(context, categories: sections, initial: item);
    if (updated == null) return;
    final ok = await menu.updateFood(updated);
    messenger.showSnackBar(
      _snackBar(ok ? AppStrings.foodUpdatedToast : AppStrings.actionFailed),
    );
  }

  Future<void> _onAddSection(BuildContext context) async {
    final menu = context.read<MenuViewModel>();
    final messenger = ScaffoldMessenger.of(context);

    final category = await showAddSectionSheet(context);
    if (category == null) return;
    menu.selectCategory(category.id);
    final ok = await menu.addCategory(category);
    messenger.showSnackBar(
      _snackBar(ok ? AppStrings.sectionAddedToast : AppStrings.actionFailed),
    );
  }

  Future<void> _onDeleteFood(BuildContext context, FoodItem item) async {
    final menu = context.read<MenuViewModel>();
    final messenger = ScaffoldMessenger.of(context);

    final confirmed = await showDeleteConfirmationDialog(context);
    if (!confirmed) return;

    final ok = await menu.deleteFood(item.id);
    if (!ok) {
      messenger.showSnackBar(_snackBar(AppStrings.actionFailed));
      return;
    }
    messenger
      ..hideCurrentSnackBar()
      ..showSnackBar(
        _snackBar(
          AppStrings.deletedToast,
          action: SnackBarAction(
            label: AppStrings.undo,
            textColor: AppColors.primary,
            onPressed: menu.undoDelete,
          ),
        ),
      );
  }

  SnackBar _snackBar(String message, {SnackBarAction? action}) {
    return SnackBar(content: Text(message), action: action, duration: const Duration(seconds: 3), margin: const EdgeInsets.all(AppSpacing.lg));
  }
}

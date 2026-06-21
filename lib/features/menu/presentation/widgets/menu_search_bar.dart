import 'package:flutter/material.dart';

import '../../../../core/localization/app_strings.dart';
import '../../../../core/theme/app_colors.dart';
import '../../../../core/theme/app_spacing.dart';
import '../../../../core/theme/app_typography.dart';

class MenuSearchBar extends StatefulWidget {
  const MenuSearchBar({super.key, required this.onChanged});

  final ValueChanged<String> onChanged;

  @override
  State<MenuSearchBar> createState() => _MenuSearchBarState();
}

class _MenuSearchBarState extends State<MenuSearchBar> {
  final TextEditingController _controller = TextEditingController();
  bool _hasText = false;

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    final hasText = value.isNotEmpty;
    if (hasText != _hasText) setState(() => _hasText = hasText);
    widget.onChanged(value);
  }

  void _clear() {
    _controller.clear();
    _onChanged('');
    FocusScope.of(context).unfocus();
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: _controller,
      onChanged: _onChanged,
      textInputAction: TextInputAction.search,
      style: AppTypography.cardTitle.copyWith(fontWeight: FontWeight.w500),
      cursorColor: AppColors.primary,
      decoration: InputDecoration(
        hintText: AppStrings.searchHint,
        hintStyle: AppTypography.hint,
        filled: true,
        fillColor: AppColors.surface,
        prefixIcon: const Icon(
          Icons.search_rounded,
          color: AppColors.textMuted,
          size: 22,
        ),
        suffixIcon: _hasText
            ? IconButton(
                onPressed: _clear,
                icon: const Icon(
                  Icons.close_rounded,
                  color: AppColors.textMuted,
                  size: 20,
                ),
              )
            : null,
        contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.md),
        enabledBorder: _border(AppColors.border),
        focusedBorder: _border(AppColors.primary, width: 1.4),
      ),
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.pill),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

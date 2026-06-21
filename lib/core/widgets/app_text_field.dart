import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../theme/app_typography.dart';

class AppTextField extends StatelessWidget {
  const AppTextField({
    super.key,
    required this.label,
    this.controller,
    this.hintText,
    this.keyboardType,
    this.validator,
    this.maxLines = 1,
    this.suffixText,
    this.textInputAction,
  });

  final String label;
  final TextEditingController? controller;
  final String? hintText;
  final TextInputType? keyboardType;
  final String? Function(String?)? validator;
  final int maxLines;
  final String? suffixText;
  final TextInputAction? textInputAction;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: AppTypography.cardTitle.copyWith(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppSpacing.sm),
        TextFormField(
          controller: controller,
          keyboardType: keyboardType,
          validator: validator,
          maxLines: maxLines,
          textInputAction: textInputAction,
          style: AppTypography.cardTitle.copyWith(fontWeight: FontWeight.w500),
          cursorColor: AppColors.primary,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: AppTypography.hint,
            suffixText: suffixText,
            suffixStyle: AppTypography.body,
            filled: true,
            fillColor: AppColors.background,
            isDense: true,
            contentPadding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
              vertical: AppSpacing.md,
            ),
            enabledBorder: _border(AppColors.border),
            focusedBorder: _border(AppColors.primary, width: 1.4),
            errorBorder: _border(AppColors.danger),
            focusedErrorBorder: _border(AppColors.danger, width: 1.4),
            errorStyle: AppTypography.body.copyWith(
              color: AppColors.danger,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  OutlineInputBorder _border(Color color, {double width = 1}) {
    return OutlineInputBorder(
      borderRadius: BorderRadius.circular(AppRadius.md),
      borderSide: BorderSide(color: color, width: width),
    );
  }
}

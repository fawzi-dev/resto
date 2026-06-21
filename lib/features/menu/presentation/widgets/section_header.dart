import 'package:flutter/material.dart';

import '../../../../core/theme/app_typography.dart';

class SectionHeader extends StatelessWidget {
  const SectionHeader({super.key, required this.title, this.trailing});

  final String title;
  final Widget? trailing;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(child: Text(title, style: AppTypography.sectionTitle)),
        if (trailing != null) trailing!,
      ],
    );
  }
}

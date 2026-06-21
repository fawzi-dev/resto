import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';

import '../theme/app_colors.dart';
import 'shimmer_box.dart';

class AppNetworkImage extends StatelessWidget {
  const AppNetworkImage({
    super.key,
    required this.url,
    this.fit = BoxFit.cover,
  });

  final String url;
  final BoxFit fit;

  @override
  Widget build(BuildContext context) {
    if (url.isEmpty) return const _ImageFallback();
    return CachedNetworkImage(
      imageUrl: url,
      fit: fit,
      fadeInDuration: const Duration(milliseconds: 250),
      placeholder: (context, _) =>
          const ShimmerBox(borderRadius: BorderRadius.zero),
      errorWidget: (context, _, __) => const _ImageFallback(),
    );
  }
}

class _ImageFallback extends StatelessWidget {
  const _ImageFallback();

  @override
  Widget build(BuildContext context) {
    return const ColoredBox(
      color: AppColors.shimmerBase,
      child: Center(
        child: Icon(
          Icons.restaurant_menu_rounded,
          color: AppColors.textMuted,
          size: 28,
        ),
      ),
    );
  }
}

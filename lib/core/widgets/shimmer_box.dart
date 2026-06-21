import 'package:flutter/material.dart';

import '../theme/app_colors.dart';

class ShimmerBox extends StatefulWidget {
  const ShimmerBox({
    super.key,
    this.width,
    this.height,
    this.borderRadius = const BorderRadius.all(Radius.circular(12)),
  });

  final double? width;
  final double? height;
  final BorderRadiusGeometry borderRadius;

  @override
  State<ShimmerBox> createState() => _ShimmerBoxState();
}

class _ShimmerBoxState extends State<ShimmerBox>
    with SingleTickerProviderStateMixin {
  late final AnimationController _controller = AnimationController(
    vsync: this,
    duration: const Duration(milliseconds: 1200),
  )..repeat();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, _) {
        return ClipRRect(
          borderRadius: widget.borderRadius.resolve(Directionality.of(context)),
          child: ShaderMask(
            blendMode: BlendMode.srcATop,
            shaderCallback: (bounds) {
              final dx = bounds.width * (_controller.value * 2 - 1);
              return LinearGradient(
                begin: Alignment.centerLeft,
                end: Alignment.centerRight,
                colors: const [
                  AppColors.shimmerBase,
                  AppColors.shimmerHighlight,
                  AppColors.shimmerBase,
                ],
                stops: const [0.35, 0.5, 0.65],
                transform: _SlideGradient(dx),
              ).createShader(bounds);
            },
            child: Container(
              width: widget.width,
              height: widget.height,
              decoration: BoxDecoration(
                color: AppColors.shimmerBase,
                borderRadius: widget.borderRadius,
              ),
            ),
          ),
        );
      },
    );
  }
}

class _SlideGradient extends GradientTransform {
  const _SlideGradient(this.dx);
  final double dx;

  @override
  Matrix4 transform(Rect bounds, {TextDirection? textDirection}) =>
      Matrix4.translationValues(dx, 0, 0);
}

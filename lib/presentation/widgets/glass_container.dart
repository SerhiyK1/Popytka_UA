import 'dart:ui';
import 'package:flutter/material.dart';
import '../theme/app_colors.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double borderRadius;
  final Border? border;
  final VoidCallback? onTap;

  const GlassContainer({
    super.key,
    required this.child,
    this.padding,
    this.margin,
    this.borderRadius = 16,
    this.border,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final fillColor = isDark ? AppColors.glassFill : Colors.white.withValues(alpha: 0.8);
    final borderColor = isDark ? AppColors.glassBorder : Colors.black12;

    // ClipRRect + BackboneFilter for blur
    return Padding(
      padding: margin ?? EdgeInsets.zero,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(borderRadius),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: GestureDetector(
            onTap: onTap,
            child: Container(
              padding: padding,
              decoration: BoxDecoration(
                color: fillColor,
                borderRadius: BorderRadius.circular(borderRadius),
                border: border ?? Border.all(color: borderColor),
              ),
              child: child,
            ),
          ),
        ),
      ),
    );
  }
}

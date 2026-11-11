import 'dart:ui';
import 'package:flutter/material.dart';

class GlassContainer extends StatelessWidget {
  final Widget child;
  final double borderRadius;
  final double blur;
  final Color? color;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final double? width;
  final double? height;

  const GlassContainer({
    super.key,
    required this.child,
    this.borderRadius = 16.0,
    this.blur = 20.0,
    this.color,
    this.padding,
    this.margin,
    this.width,
    this.height,
  });

  @override
  Widget build(BuildContext context) {
    final BorderRadius radius = BorderRadius.circular(borderRadius);

    return Container(
      width: width,
      height: height,
      margin: margin,
      child: ClipRRect(
        borderRadius: radius,
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),
          child: Container(
            padding: padding,
            decoration: BoxDecoration(
              color: color ?? Colors.white.withValues(alpha: 0.05),
              borderRadius: radius,
              border: Border.all(
                color: Colors.white.withValues(alpha: 0.1),
                width: 1.0,
              ),
            ),
            child: child,
          ),
        ),
      ),
    );
  }
}

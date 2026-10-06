import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CustomCard extends StatelessWidget {
  final String title;
  final String description;
  final double? elevation;
  final Color? backgroundColor;
  final Color? borderColor;
  final double? borderWidth;
  final BorderRadius? borderRadius;
  final EdgeInsetsGeometry? padding;
  final EdgeInsetsGeometry? margin;
  final ShapeBorder? customShape;
  final List<BoxShadow>? boxShadow;

  const CustomCard({
    super.key,
    required this.title,
    required this.description,
    this.elevation,
    this.backgroundColor,
    this.borderColor,
    this.borderWidth,
    this.borderRadius,
    this.padding,
    this.margin,
    this.customShape,
    this.boxShadow,
  });

  @override
  Widget build(BuildContext context) {
    // Detect current theme mode
    final isDarkMode = Get.isDarkMode;

    return Container(
      margin: margin ?? const EdgeInsets.all(16),
      padding: padding ?? const EdgeInsets.all(16),
      decoration: ShapeDecoration(
        color:
            backgroundColor ?? (isDarkMode ? Colors.grey[800] : Colors.white),
        shape: customShape ??
            RoundedRectangleBorder(
              borderRadius: borderRadius ?? BorderRadius.circular(12),
              side: BorderSide(
                color: borderColor ?? Colors.transparent,
                width: borderWidth ?? 0,
              ),
            ),
        shadows: boxShadow ??
            [
              BoxShadow(
                color:
                    isDarkMode ? Colors.black54 : Colors.grey.withOpacity(0.5),
                blurRadius: elevation ?? 8,
                offset: const Offset(0, 4),
              ),
            ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            title,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  color: isDarkMode ? Colors.white : Colors.black,
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: 8),
          Text(
            description,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: isDarkMode ? Colors.grey[300] : Colors.grey[800],
                ),
          ),
        ],
      ),
    );
  }
}

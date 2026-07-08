import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_size.dart';

class AppPanel extends StatelessWidget {
  final Widget child;

  final EdgeInsetsGeometry padding;

  final Color? color;

  final double? width;

  final double? height;

  final VoidCallback? onTap;

  final bool selected;

  const AppPanel({
    super.key,
    required this.child,
    this.padding = const EdgeInsets.all(AppSizes.padding),
    this.color,
    this.width,
    this.height,
    this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    final borderColor =
    selected ? AppColors.selected : AppColors.slotBorder;

    Widget body = AnimatedContainer(
      duration: const Duration(milliseconds: 120),
      width: width,
      height: height,
      padding: padding,
      decoration: BoxDecoration(
        color: color ?? AppColors.panel,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        border: Border.all(
          color: borderColor,
          width: AppSizes.border,
        ),
      ),
      child: child,
    );

    if (onTap == null) {
      return body;
    }

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radius),
        onTap: onTap,
        child: body,
      ),
    );
  }
}
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_size.dart';

enum AppButtonType {
  primary,
  secondary,
  danger,
}

class AppButton extends StatelessWidget {
  final String text;

  final IconData? icon;

  final VoidCallback? onPressed;

  final AppButtonType type;

  final double? width;

  final double height;

  const AppButton({
    super.key,
    required this.text,
    this.icon,
    this.onPressed,
    this.type = AppButtonType.primary,
    this.width,
    this.height = AppSizes.buttonHeight,
  });

  Color get _background {
    switch (type) {
      case AppButtonType.primary:
        return AppColors.leaf;

      case AppButtonType.secondary:
        return AppColors.paper;

      case AppButtonType.danger:
        return AppColors.danger;
    }
  }

  Color get _foreground {
    switch (type) {
      case AppButtonType.secondary:
        return AppColors.tree;

      default:
        return AppColors.white;
    }
  }

  @override
  Widget build(BuildContext context) {
    final enabled = onPressed != null;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        onTap: onPressed,
        borderRadius: BorderRadius.circular(AppSizes.radius),
        child: Opacity(
          opacity: enabled ? 1 : .55,
          child: Container(
            width: width,
            height: height,
            decoration: BoxDecoration(
              color: _background,
              borderRadius: BorderRadius.circular(AppSizes.radius),
              border: Border.all(
                color: AppColors.border,
                width: AppSizes.border,
              ),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [

                if (icon != null) ...[
                  Icon(
                    icon,
                    size: 18,
                    color: _foreground,
                  ),
                  const SizedBox(width: 8),
                ],

                Text(
                  text,
                  style: TextStyle(
                    color: _foreground,
                    fontWeight: FontWeight.bold,
                    fontSize: 16,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
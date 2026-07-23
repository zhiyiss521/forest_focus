import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_size.dart';

class InventorySlot extends StatelessWidget {
  const InventorySlot({
    super.key,
    required this.image,
    this.selected = false,
    this.onTap,
    this.size = AppSizes.slotSize,
    this.badge,
  });

  final Widget image;
  final bool selected;
  final VoidCallback? onTap;
  final double size;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radius),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: size,
          height: size,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: selected
                ? AppColors.background.withOpacity(0.25)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.radius),
          ),
          child: Stack(
            children: [
              Center(
                child: image,
              ),
              if (badge != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: badge!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
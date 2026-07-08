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

  /// 图片
  final Widget image;

  /// 是否选中
  final bool selected;

  /// 点击
  final VoidCallback? onTap;

  /// 格子尺寸
  final double size;

  /// 角标
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
                ? AppColors.selected.withOpacity(0.25)
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
import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_size.dart';

class AppDivider extends StatelessWidget {
  const AppDivider({
    super.key,
    this.widthFactor = 0.9,
    this.height = 1,
    this.margin = const EdgeInsets.symmetric(vertical: 6),
  });

  /// 占父组件宽度的比例
  final double widthFactor;

  /// 线宽
  final double height;

  final EdgeInsetsGeometry margin;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: margin,
      child: FractionallySizedBox(
        widthFactor: widthFactor,
        child: Container(
          height: height,
          decoration: BoxDecoration(
            color: AppColors.slotBorder.withValues(alpha: 0.35),
            borderRadius: BorderRadius.circular(height),
          ),
        ),
      ),
    );
  }
}
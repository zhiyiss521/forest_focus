import 'package:flutter/material.dart';

import '../../theme/app_size.dart';

class InventoryGrid extends StatelessWidget {
  const InventoryGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    /// 滚动方向
    this.scrollDirection = Axis.vertical,
    /// 竖向滚动：每行几个
    /// 横向滚动：每列几个
    this.crossAxisCount = 4,
    /// width / height
    this.childAspectRatio = 1.0,
    this.padding = const EdgeInsets.all(AppSizes.padding),
    this.spacing = 0,
    this.physics,
    this.shrinkWrap = false,
  });

  /// Item 数量
  final int itemCount;

  /// Item Builder
  final IndexedWidgetBuilder itemBuilder;

  /// 滚动方向
  final Axis scrollDirection;

  /// crossAxis 数量
  final int crossAxisCount;

  /// 宽高比（width / height）
  final double childAspectRatio;

  /// Padding
  final EdgeInsetsGeometry padding;

  /// 横向、纵向间距
  final double spacing;

  /// ScrollPhysics
  final ScrollPhysics? physics;

  /// 是否收缩
  final bool shrinkWrap;

  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      scrollDirection: scrollDirection,
      padding: padding,
      physics: physics,
      shrinkWrap: shrinkWrap,
      itemCount: itemCount,
      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: crossAxisCount,
        crossAxisSpacing: spacing,
        mainAxisSpacing: spacing,
        childAspectRatio: childAspectRatio,
      ),
      itemBuilder: itemBuilder,
    );
  }
}
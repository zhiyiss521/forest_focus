import 'package:flutter/material.dart';

import '../../theme/app_size.dart';

class InventoryGrid extends StatelessWidget {
  const InventoryGrid({
    super.key,
    required this.itemCount,
    required this.itemBuilder,
    this.scrollDirection = Axis.vertical,
    this.crossAxisCount = 4,
    this.childAspectRatio = 1.0,
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
import 'package:flutter/material.dart';
import '../../theme/app_colors.dart';
import 'app_panel.dart';

class ItemPreviewPanel extends StatelessWidget {
  const ItemPreviewPanel({
    super.key,
    this.image,
    this.title,
    this.subtitle,
    this.placeholder = '请选择一个素材',
  });

  /// 图片
  final Widget? image;

  /// 名称
  final String? title;

  /// 副标题（类型、分类等）
  final String? subtitle;

  /// 未选择时显示
  final String placeholder;

  @override
  Widget build(BuildContext context) {
    final hasItem = image != null;

    return AppPanel(
      padding: const EdgeInsets.all(20),
      child: SizedBox(
        height: 180,
        child: hasItem
            ? Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [

            SizedBox(
              width: 80,
              height: 80,
              child: FittedBox(
                fit: BoxFit.contain,
                child: image!,
              ),
            ),

            const SizedBox(height: 12),

            Text(
              title ?? '',
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.black,
              ),
              textAlign: TextAlign.center,
            ),

            if (subtitle != null) ...[
              const SizedBox(height: 6),
              Text(
                subtitle!,
                style: const TextStyle(
                  color: AppColors.slotBorder,
                  fontSize: 14,
                ),
              ),
            ],
          ],
        )
            : Center(
          child: Text(
            placeholder,
            style: const TextStyle(
              color: AppColors.slotBorder,
              fontSize: 16,
            ),
          ),
        ),
      ),
    );
  }
}
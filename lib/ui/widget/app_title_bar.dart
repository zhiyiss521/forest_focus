import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_size.dart';

class AppTitleBar extends StatelessWidget {
  final String title;

  /// 左侧图标
  final Widget? leading;

  /// 右侧按钮（以后可放搜索、金币等）
  final List<Widget>? trailing;

  /// 是否显示关闭按钮
  final bool showClose;

  final VoidCallback? onClose;

  const AppTitleBar({
    super.key,
    required this.title,
    this.leading,
    this.trailing,
    this.showClose = true,
    this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: AppSizes.titleHeight,
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: const BoxDecoration(
        color: AppColors.leaf,
        border: Border(
          bottom: BorderSide(
            color: AppColors.border,
            width: AppSizes.border,
          ),
        ),
      ),
      child: Row(
        children: [

          if (leading != null) ...[
            IconTheme(
              data: const IconThemeData(
                color: AppColors.white,
                size: 22,
              ),
              child: leading!,
            ),
            const SizedBox(width: 10),
          ],

          Expanded(
            child: Text(
              title,
              style: const TextStyle(
                color: AppColors.white,
                fontSize: 18,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.2,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),

          if (trailing != null) ...trailing!,

          if (showClose) ...[
            if (trailing != null) const SizedBox(width: 8),

            _CloseButton(
              onPressed: onClose ??
                      () {
                    Navigator.of(context).pop();
                  },
            ),
          ],
        ],
      ),
    );
  }
}

class _CloseButton extends StatelessWidget {
  final VoidCallback onPressed;

  const _CloseButton({
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(AppSizes.radius),
      onTap: onPressed,
      child: Container(
        width: 34,
        height: 34,
        decoration: BoxDecoration(
          color: AppColors.danger,
          border: Border.all(
            color: AppColors.border,
            width: AppSizes.border,
          ),
          borderRadius: BorderRadius.circular(AppSizes.radius),
        ),
        alignment: Alignment.center,
        child: const Icon(
          Icons.close_rounded,
          color: AppColors.white,
          size: 18,
        ),
      ),
    );
  }
}
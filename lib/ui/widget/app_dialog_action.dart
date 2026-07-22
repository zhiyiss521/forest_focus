import 'package:flutter/material.dart';

import '../../theme/app_size.dart';
import 'ff_button.dart';

class AppDialogActions extends StatelessWidget {
  final VoidCallback? onCancel;

  final VoidCallback? onConfirm;

  final String cancelText;

  final String confirmText;

  final bool enabled;

  const AppDialogActions({
    super.key,
    this.onCancel,
    this.onConfirm,
    this.cancelText = "取消",
    this.confirmText = "确定",
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(AppSizes.padding),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.end,
        children: [

          Expanded(
            child: FFButton(
              text: cancelText,
              type: FFButtonType.secondary,
              onPressed: onCancel,
            ),
          ),

          const SizedBox(width: AppSizes.gap * 2),

          Expanded(
            child: FFButton(
              text: confirmText,
              onPressed: enabled ? onConfirm : null,
            ),
          ),
        ],
      ),
    );
  }
}
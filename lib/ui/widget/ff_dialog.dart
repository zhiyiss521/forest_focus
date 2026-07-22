import 'package:flutter/material.dart';
import 'package:forest_focus/theme/app_colors.dart';
import 'package:forest_focus/theme/app_size.dart';

import 'ff_button.dart';

class FFDialog extends StatelessWidget {
  final String title;
  final String message;
  final String confirmText;
  final String? cancelText;
  final VoidCallback onConfirm;
  final VoidCallback? onCancel;

  const FFDialog({
    super.key,
    required this.title,
    required this.message,
    required this.confirmText,
    required this.onConfirm,
    this.cancelText,
    this.onCancel,
  });

  static Future<T?> show<T>(
      BuildContext context, {
        required String title,
        required String message,
        required String confirmText,
        String? cancelText,
        required VoidCallback onConfirm,
        VoidCallback? onCancel,
      }) {
    return showDialog<T>(
      context: context,
      builder: (_) => FFDialog(
        title: title,
        message: message,
        confirmText: confirmText,
        cancelText: cancelText,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const offset = 6.0;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Padding(
        padding: const EdgeInsets.only(bottom: offset),
        child: Stack(
          clipBehavior: Clip.none,
          children: [
            Positioned(
              top: offset,
              left: 0,
              right: 0,
              bottom: -offset,
              child: _paper(AppColors.background),
            ),

            _paper(
              const Color(0xFFF8F1E7),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  const SizedBox(height: 12),

                  Text(
                    message,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 15,
                      height: 1.4,
                    ),
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      if (cancelText != null) ...[
                        Expanded(
                          child: FFButton(
                            type: FFButtonType.secondary,
                            height: 44,
                            text: cancelText!,
                            onPressed:
                            onCancel ?? () => Navigator.pop(context),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],

                      Expanded(
                        child: FFButton(
                          height: 44,
                          text: confirmText,
                          onPressed: onConfirm,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _paper(Color color, {Widget? child,}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(
          AppSizes.buttonCornerRadius,
        ),
      ),
      child: child,
    );
  }

}
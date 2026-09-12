import 'package:flutter/material.dart';
import 'package:forest_focus/theme/app_size.dart';

import 'ff_button.dart';

class FFInputDialog extends StatefulWidget {
  final String title;
  final String? message;
  final String hintText;
  final String confirmText;
  final String? cancelText;
  final String? initialValue;
  final TextInputType? keyboardType;
  final Future<void> Function(String value) onConfirm;
  final VoidCallback? onCancel;

  const FFInputDialog({
    super.key,
    required this.title,
    this.message,
    required this.hintText,
    required this.confirmText,
    this.cancelText,
    this.initialValue,
    this.keyboardType,
    required this.onConfirm,
    this.onCancel,
  });

  static Future<T?> show<T>(
      BuildContext context, {
        required String title,
        String? message,
        required String hintText,
        required String confirmText,
        String? cancelText,
        String? initialValue,
        TextInputType? keyboardType,
        required Future<void> Function(String value) onConfirm,
        VoidCallback? onCancel,
      }) {
    return showDialog<T>(
      context: context,
      builder: (_) => FFInputDialog(
        title: title,
        message: message,
        hintText: hintText,
        confirmText: confirmText,
        cancelText: cancelText,
        initialValue: initialValue,
        keyboardType: keyboardType,
        onConfirm: onConfirm,
        onCancel: onCancel,
      ),
    );
  }

  @override
  State<FFInputDialog> createState() => _FFInputDialogState();
}

class _FFInputDialogState extends State<FFInputDialog> {
  late final TextEditingController _controller;

  bool _isLoading = false;

  @override
  void initState() {
    super.initState();

    _controller = TextEditingController(
      text: widget.initialValue,
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _confirm() async {
    final value = _controller.text.trim();

    if (value.isEmpty) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      await widget.onConfirm(value);

      if (mounted) {
        Navigator.of(context).pop();
      }
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    const offset = 6.0;

    return Dialog(
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
              child: _paper(),
            ),

            _paper(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    widget.title,
                    textAlign: TextAlign.center,
                    style: const TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.w700,
                    ),
                  ),

                  if (widget.message != null) ...[
                    const SizedBox(height: 12),
                    Text(
                      widget.message!,
                      textAlign: TextAlign.center,
                      style: const TextStyle(
                        fontSize: 15,
                        height: 1.4,
                      ),
                    ),
                  ],

                  const SizedBox(height: 24),

                  TextField(
                    controller: _controller,
                    autofocus: true,
                    keyboardType: widget.keyboardType,
                    enabled: !_isLoading,
                    decoration: InputDecoration(
                      hintText: widget.hintText,
                    ),
                    onSubmitted: (_) {
                      if (!_isLoading) {
                        _confirm();
                      }
                    },
                  ),

                  const SizedBox(height: 24),

                  Row(
                    children: [
                      if (widget.cancelText != null) ...[
                        Expanded(
                          child: FFButton(
                            type: FFButtonType.secondary,
                            height: 44,
                            text: widget.cancelText!,
                            onPressed: _isLoading
                                ? null
                                : widget.onCancel ??
                                    () => Navigator.of(context).pop(),
                          ),
                        ),
                        const SizedBox(width: 12),
                      ],

                      Expanded(
                        child: FFButton(
                          height: 44,
                          text: widget.confirmText,
                          onPressed: _isLoading ? null : _confirm,
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

  Widget _paper({Widget? child}) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(
          AppSizes.buttonCornerRadius,
        ),
      ),
      child: child,
    );
  }
}
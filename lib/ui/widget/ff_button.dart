import 'package:flutter/material.dart';

import '../../theme/app_colors.dart';
import '../../theme/app_size.dart';

enum FFButtonType {
  primary,
  secondary,
  danger,
}

class FFButton extends StatefulWidget {
  final String text;
  final VoidCallback? onPressed;
  final FFButtonType type;
  final double? width;
  final double height;

  const FFButton({
    super.key,
    required this.text,
    this.onPressed,
    this.type = FFButtonType.primary,
    this.width,
    this.height = AppSizes.buttonHeight,
  });

  @override
  State<FFButton> createState() => _FFButtonState();
}

class _FFButtonState extends State<FFButton> {
  bool _pressed = false;

  Color get _background => switch (widget.type) {
    FFButtonType.primary => AppColors.primary,
    FFButtonType.secondary => AppColors.secondary,
    FFButtonType.danger => AppColors.danger,
  };

  Color get _base {
    final hsl = HSLColor.fromColor(_background);
    return hsl
        .withLightness((hsl.lightness - 0.12).clamp(0.0, 1.0))
        .toColor();
  }

  @override
  Widget build(BuildContext context) {
    const offset = 4.0;

    return Opacity(
      opacity: widget.onPressed == null ? .45 : 1,
      child: SizedBox(
        width: widget.width,
        height: widget.height + offset,
        child: GestureDetector(
          onTapDown: (_) => setState(() => _pressed = true),
          onTapUp: (_) => setState(() => _pressed = false),
          onTapCancel: () => setState(() => _pressed = false),
          onTap: widget.onPressed,
          child: Stack(
            children: [
              Positioned.fill(
                top: offset,
                child: DecoratedBox(
                  decoration: BoxDecoration(
                    color: _base,
                    borderRadius: BorderRadius.circular(
                      AppSizes.buttonCornerRadius,
                    ),
                  ),
                ),
              ),
              AnimatedPositioned(
                duration: const Duration(milliseconds: 80),
                curve: Curves.easeOut,
                top: _pressed ? offset : 0,
                left: 0,
                right: 0,
                child: Container(
                  height: widget.height,
                  decoration: BoxDecoration(
                    color: _background,
                    borderRadius: BorderRadius.circular(
                      AppSizes.buttonCornerRadius,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      color: AppColors.textLight,
                      fontSize: AppSizes.buttonTextFontSize,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
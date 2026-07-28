import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../theme/app_size.dart';
import '../../theme/ff_color_config.dart';
import '../../theme/ff_theme_provider.dart';

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

  Color _background(BuildContext context) {
    return switch (widget.type) {
      FFButtonType.primary => Theme.of(context).colorScheme.primary,
      FFButtonType.secondary => Theme.of(context).colorScheme.secondary,
      FFButtonType.danger => Theme.of(context).colorScheme.error,
    };
  }

  Color _base(Color color) {
    final hsl = HSLColor.fromColor(color);
    return hsl.withLightness((hsl.lightness - 0.12).clamp(0.0, 1.0),).toColor();
  }

  @override
  Widget build(BuildContext context) {
    const offset = 4.0;
    final background = _background(context);
    final base = _base(background);

    return Opacity(
      opacity: widget.onPressed == null ? .45 : 1,
      child: SizedBox(
        width: widget.width ?? double.infinity,
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
                    color: base,
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
                    color: background,
                    borderRadius: BorderRadius.circular(
                      AppSizes.buttonCornerRadius,
                    ),
                  ),
                  alignment: Alignment.center,
                  child: Text(
                    widget.text,
                    style: TextStyle(
                      color: Theme.of(context).cardColor,
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
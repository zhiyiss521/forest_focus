import 'package:flutter/material.dart';
import 'package:forest_focus/theme/ff_theme_provider.dart';
import 'package:provider/provider.dart';
import '../../theme/app_size.dart';

class InventorySlot extends StatelessWidget {
  const InventorySlot({
    super.key,
    required this.image,
    this.selected = false,
    this.onTap,
    this.size = AppSizes.slotSize,
    this.badge,
  });

  final Widget image;
  final bool selected;
  final VoidCallback? onTap;
  final double size;
  final Widget? badge;

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<FFThemeProvider>().current!.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(AppSizes.radius),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          width: size,
          height: size,
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: selected ? Theme.of(context).colorScheme.secondary: Colors.transparent,
            borderRadius: BorderRadius.circular(AppSizes.radius),
          ),
          child: Stack(
            children: [
              Center(child: image,),
              if (badge != null)
                Positioned(
                  top: 0,
                  right: 0,
                  child: badge!,
                ),
            ],
          ),
        ),
      ),
    );
  }
}
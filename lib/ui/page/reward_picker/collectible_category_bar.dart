import 'package:flutter/material.dart';
import 'package:forest_focus/l10n/app_localizations.dart';
import 'package:forest_focus/l10n/app_localizations_en.dart';
import 'package:forest_focus/theme/ff_theme_provider.dart';
import 'package:provider/provider.dart';
import '../../../model/collectible_item.dart';
import '../../../theme/app_size.dart';

class CollectibleCategoryBar extends StatelessWidget {
  const CollectibleCategoryBar({
    super.key,
    required this.categories,
    required this.selectedType,
    required this.onSelected,
  });

  final List<CollectibleType?> categories;

  final CollectibleType? selectedType;

  final ValueChanged<CollectibleType?> onSelected;

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 52,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(
          horizontal: AppSizes.padding,
          vertical: 8,
        ),
        itemCount: categories.length,
        separatorBuilder: (_, __) =>
        const SizedBox(width: AppSizes.gap),
        itemBuilder: (_, index) {
          final type = categories[index];
          final selected = type == selectedType;

          return _CategoryChip(
            title: type?.displayName ?? AppLocalizations.of(context)!.all,
            selected: selected,
            onTap: () => onSelected(type),
          );
        },
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  const _CategoryChip({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  final String title;
  final bool selected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final colors = context.watch<FFThemeProvider>().current!.colors;

    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: BorderRadius.circular(999),
        onTap: onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 150),
          curve: Curves.easeOut,
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 6,
          ),
          decoration: BoxDecoration(
            color: selected
                ? colors.secondaryColor
                : Colors.transparent,
            borderRadius: BorderRadius.circular(999),
          ),
          child: Center(
            child: Text(
              title,
              style: TextStyle(
                fontSize: 14,
                fontWeight:
                selected ? FontWeight.w700 : FontWeight.w500,
              ),
            ),
          ),
        ),
      ),
    );
  }
}
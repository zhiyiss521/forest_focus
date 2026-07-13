import 'package:flutter/material.dart';
import 'package:forest_focus/ui/page/sta/sta_provider.dart';
import 'package:provider/provider.dart';
import '../../../model/sta_range.dart';

class StaRangeHeader extends StatelessWidget {
  const StaRangeHeader({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StaProvider>();

    return Row(
      children: [
        Expanded(
          child: _RangeButton(
            title: "Day",
            selected: provider.range == StaRange.day,
            onTap: () {
              context.read<StaProvider>().changeRange(
                StaRange.day,
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _RangeButton(
            title: "Week",
            selected: provider.range == StaRange.week,
            onTap: () {
              context.read<StaProvider>().changeRange(
                StaRange.week,
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _RangeButton(
            title: "Month",
            selected: provider.range == StaRange.month,
            onTap: () {
              context.read<StaProvider>().changeRange(
                StaRange.month,
              );
            },
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: _RangeButton(
            title: "Year",
            selected: provider.range == StaRange.year,
            onTap: () {
              context.read<StaProvider>().changeRange(
                StaRange.year,
              );
            },
          ),
        ),
      ],
    );
  }
}

class _RangeButton extends StatelessWidget {
  final String title;
  final bool selected;
  final VoidCallback onTap;

  const _RangeButton({
    required this.title,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.primary;

    return InkWell(
      borderRadius: BorderRadius.circular(24),
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 220),
        curve: Curves.easeOut,
        height: 42,
        decoration: BoxDecoration(
          color: selected ? color : Colors.transparent,
          borderRadius: BorderRadius.circular(24),
          border: Border.all(
            color: selected
                ? color
                : Colors.grey.shade300,
          ),
        ),
        alignment: Alignment.center,
        child: Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w600,
            color: selected
                ? Colors.white
                : Colors.black87,
          ),
        ),
      ),
    );
  }
}
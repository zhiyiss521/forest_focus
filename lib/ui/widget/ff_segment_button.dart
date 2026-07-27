import 'package:flutter/material.dart';

class FFSegmentButton<T> extends StatelessWidget {
  final List<FFSegmentItem<T>> items;
  final T selected;
  final ValueChanged<T> onChanged;
  final double height;

  const FFSegmentButton({
    super.key,
    required this.items,
    required this.selected,
    required this.onChanged,
    this.height = 42,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(height / 2),
      ),
      child: Row(
        children: items.map((item) {
          final active = item.value == selected;

          return Expanded(
            child: GestureDetector(
              onTap: () => onChanged(item.value),
              child: AnimatedContainer(
                duration: const Duration(milliseconds: 180),
                curve: Curves.easeOut,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: active
                      ? const Color(0xFFE8B84A)
                      : Colors.transparent,
                  borderRadius: BorderRadius.circular(height / 2),
                ),
                child: Text(
                  item.title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: active
                        ? Colors.white
                        : Colors.black54,
                  ),
                ),
              ),
            ),
          );
        }).toList(),
      ),
    );
  }
}

class FFSegmentItem<T> {
  final String title;
  final T value;

  const FFSegmentItem({
    required this.title,
    required this.value,
  });
}
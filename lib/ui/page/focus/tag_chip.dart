import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../model/tag.dart';

class TagChip extends StatelessWidget {
  final Tag tag;
  final VoidCallback? onTap;

  const TagChip({
    super.key,
    required this.tag,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color: Color(tag.color).withOpacity(0.15),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Color(tag.color).withOpacity(0.4),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            tag.icon,
            style: const TextStyle(fontSize: 18),
          ),
          const SizedBox(width: 6),
          Text(
            tag.name,
            style: TextStyle(
              color: Color(tag.color),
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );

    if (onTap == null) {
      return child;
    }

    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: child,
    );
  }
}
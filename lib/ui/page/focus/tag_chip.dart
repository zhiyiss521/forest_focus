import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import '../../../model/tag.dart';

class TagChip extends StatelessWidget {
  final Tag tag;
  final VoidCallback? onTap;
  final bool isSelected;

  const TagChip({
    super.key,
    required this.tag,
    this.onTap,
    this.isSelected = false
  });

  @override
  Widget build(BuildContext context) {
    final child = Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
      ),
      decoration: BoxDecoration(
        color: isSelected ? Color(tag.color).withOpacity(0.15) : Colors.transparent,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.circle,
            size: 15,
            color: Color(tag.color),
          ),
          SizedBox(width: 10,),
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
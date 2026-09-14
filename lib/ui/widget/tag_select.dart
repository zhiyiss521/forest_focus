import 'package:flutter/cupertino.dart';

import '../../core/model/tag.dart';
import '../page/focus/tag_chip.dart';

class TagSelect extends StatelessWidget {
  final List<Tag> tags;
  final int selectedTagId;
  final ValueChanged<int> onChanged;

  const TagSelect({
    super.key,
    required this.tags,
    required this.selectedTagId,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      scrollDirection: Axis.horizontal,
      itemCount: tags.length,
      separatorBuilder: (_, __) => const SizedBox(width: 8),
      itemBuilder: (_, index) {
        final tag = tags[index];
        return TagChip(
          tag: tag,
          isSelected: tag.id == selectedTagId,
          onTap: () => onChanged(tag.id!),
        );
      },
    );
  }
}
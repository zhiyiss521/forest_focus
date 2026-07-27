import 'package:flutter/material.dart';
import '../../theme/app_size.dart';
import '../../model/tag.dart';
import 'ff_button.dart';

class FFTagSelectDialog extends StatefulWidget {
  final List<Tag> tags;
  final List<Tag> selectedTags;
  final ValueChanged<List<Tag>> onConfirm;

  const FFTagSelectDialog({
    super.key,
    required this.tags,
    required this.selectedTags,
    required this.onConfirm,
  });

  static Future<void> show(
      BuildContext context, {
        required List<Tag> tags,
        required List<Tag> selectedTags,
        required ValueChanged<List<Tag>> onConfirm,
      }) {
    return showDialog(
      context: context,
      builder: (_) {
        return FFTagSelectDialog(
          tags: tags,
          selectedTags: selectedTags,
          onConfirm: onConfirm,
        );
      },
    );
  }

  @override
  State<FFTagSelectDialog> createState() => _FFTagSelectDialogState();
}

class _FFTagSelectDialogState extends State<FFTagSelectDialog> {
  late List<Tag> selected;

  @override
  void initState() {
    super.initState();
    selected = [...widget.selectedTags];
  }

  void _toggle(Tag tag) {
    setState(() {
      if (selected.contains(tag)) {
        if (selected.length <= 1) {
          return;
        }
        selected.remove(tag);
      } else {
        selected.add(tag);
      }
    });
  }

  void _toggleAll() {
    setState(() {
      if (selected.length == widget.tags.length) {
        if (widget.tags.isNotEmpty) {
          selected = [widget.tags.first];
        }
      } else {
        selected = [...widget.tags];
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final allSelected =
        selected.length == widget.tags.length;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: Container(
        padding: const EdgeInsets.all(24),
        decoration: BoxDecoration(
          color: const Color(0xFFF8F1E7),
          borderRadius: BorderRadius.circular(
            AppSizes.buttonCornerRadius,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                const Text(
                  "选择标签",
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const Spacer(),
                TextButton(
                  onPressed: _toggleAll,
                  child: Text(
                    allSelected
                        ? "取消全选"
                        : "全选",
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            ConstrainedBox(
              constraints: const BoxConstraints(
                maxHeight: 320,
              ),
              child: ListView.separated(
                shrinkWrap: true,
                itemCount: widget.tags.length,
                separatorBuilder: (_, __) =>
                const SizedBox(height: 8),
                itemBuilder: (_, index) {
                  final tag = widget.tags[index];

                  return _TagItem(
                    tag: tag,
                    selected: selected.contains(tag),
                    onTap: () {
                      _toggle(tag);
                    },
                  );
                },
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: FFButton(
                    type: FFButtonType.secondary,
                    text: "取消",
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: FFButton(
                    text: "确认",
                    onPressed: () {
                      widget.onConfirm(selected);
                      Navigator.pop(context);
                    },
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _TagItem extends StatelessWidget {
  final Tag tag;
  final bool selected;
  final VoidCallback onTap;

  const _TagItem({
    required this.tag,
    required this.selected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final color = Color(tag.color);

    return InkWell(
      borderRadius: BorderRadius.circular(14),
      onTap: onTap,
      child: Container(
        height: 48,
        padding: const EdgeInsets.symmetric(
          horizontal: 14,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                tag.name,
              ),
            ),
            Icon(
              selected
                  ? Icons.check_circle
                  : Icons.circle_outlined,
              color: selected
                  ? color
                  : Colors.grey,
              size: 22,
            ),
          ],
        ),
      ),
    );
  }
}
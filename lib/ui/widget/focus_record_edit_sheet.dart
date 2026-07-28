import 'package:flutter/material.dart';
import 'package:forest_focus/ui/widget/ff_button.dart';
import 'package:forest_focus/ui/widget/tag_select.dart';
import 'package:provider/provider.dart';
import '../../../model/focus_record.dart';
import '../page/reward_picker/collectible_provider.dart';
import '../page/tag/tag_provider.dart';

class FocusRecordEditSheet extends StatefulWidget {
  final FocusRecord record;
  final Future<void> Function(FocusRecord record) onSave;
  final Future<void> Function(FocusRecord record)? onDelete;

  const FocusRecordEditSheet({
    super.key,
    required this.record,
    required this.onSave,
    this.onDelete
  });

  @override
  State<FocusRecordEditSheet> createState() => _FocusEditSheetState();

  static Future<bool?> show(
      BuildContext context,
      FocusRecord record,
      {
        required Future<void> Function(FocusRecord record) onSave,
        Future<void> Function(FocusRecord record)? onDelete,
      }) {
    return showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FocusRecordEditSheet(
        record: record,
        onSave: onSave,
        onDelete: onDelete,
      ),
    );
  }
}

class _FocusEditSheetState extends State<FocusRecordEditSheet> {
  late TextEditingController noteController;
  late int selectedTagId;

  @override
  void initState() {
    super.initState();
    noteController = TextEditingController(text: widget.record.note ?? '');
    selectedTagId = widget.record.tagId;
  }

  @override
  void dispose() {
    noteController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final tagProvider = context.watch<TagProvider>();
    final collectibleProvider = context.watch<CollectibleProvider>();
    final collectible = collectibleProvider.getById(widget.record.collectibleItemId);

    return Container(
      padding: EdgeInsets.only(
        left: 24,
        right: 24,
        top: 20,
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
      ),
      decoration: BoxDecoration(
        color: Theme.of(context).scaffoldBackgroundColor,
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(28),
        ),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Center(
            child: Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (collectible != null)
            Container(
              width: 56,
              height: 56,
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.secondary,
                borderRadius: BorderRadius.circular(28),
              ),
              child: Image.asset(
                collectible.assetPath,
                filterQuality: FilterQuality.none,
              ),
            ),
          const SizedBox(height: 20),
          TextField(
            controller: noteController,
            maxLength: 250,
            maxLines: 3,
            decoration: InputDecoration(
              hintText: '记录一下现在的想法',
              filled: true,
              fillColor: Theme.of(context).cardColor,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          const SizedBox(height: 12),
          SizedBox(
            height: 32,
            child: TagSelect(
              tags: tagProvider.items,
              selectedTagId: selectedTagId,
              onChanged: (tagId) {
                setState(() {
                  selectedTagId = tagId;
                });
              },
            ),
          ),
          const SizedBox(height: 24),
          Row(
            children: [
              if (widget.onDelete != null) ...[
                Expanded(
                  child: FFButton(
                    text: "删除",
                    type: FFButtonType.danger,
                    onPressed: ()async{
                      widget.record.note = noteController.text.trim().isEmpty ? null : noteController.text.trim();
                      widget.record.tagId = selectedTagId;
                      Navigator.pop(context, true);
                      await widget.onDelete!(widget.record);
                    },
                  ),
                ),
                const SizedBox(width: 12),
              ],
              Expanded(
                child: FFButton(
                  text: "保存",
                  onPressed: ()async{
                    widget.record.note = noteController.text.trim().isEmpty ? null : noteController.text.trim();
                    widget.record.tagId = selectedTagId;
                    Navigator.pop(context, true);
                    await widget.onSave(widget.record);
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
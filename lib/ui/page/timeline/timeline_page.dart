import 'package:flutter/material.dart';
import 'package:forest_focus/ui/page/timeline/timeline_provider.dart';
import 'package:forest_focus/util/extension.dart';
import 'package:provider/provider.dart';

import '../../../core/repository/focus_record_repository.dart';
import '../../../model/focus_record.dart';
import '../../widget/ff_dialog.dart';
import '../../widget/focus_record_edit_sheet.dart';
import '../reward_picker/collectible_provider.dart';
import '../tag/tag_provider.dart';

class TimelinePage extends StatelessWidget {
  const TimelinePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => TimelineProvider()..load(),
      child: const _TimelineView(),
    );
  }
}

class _TimelineView extends StatelessWidget {
  const _TimelineView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<TimelineProvider>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text('专注记录'),
      ),
      body: provider.loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.records.length,
        itemBuilder: (_, index) {
          final record = provider.records[index];

          final showDate = index == 0 ||
              !_sameDay(
                provider.records[index - 1].createdAt,
                record.createdAt,
              );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (showDate)
                _DateHeader(
                  date: record.createdAt,
                ),
              InkWell(
                onTap: () async{
                  FocusRecordEditSheet.show(
                      context,
                      record,
                      onSave: (record) async{
                        provider.updateRecord(record);
                      },
                      onDelete: (record) async{
                        FFDialog.show(
                            context,
                            title: "确定要删除吗?",
                            confirmText: "确定",
                            onConfirm: () async {
                              Navigator.of(context).pop();
                              provider.deleteRecord(record);
                            },
                        );
                      }
                  );
                },
                child: JournalCell(
                  record: record,
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  bool _sameDay(DateTime a, DateTime b) {
    return a.year == b.year &&
        a.month == b.month &&
        a.day == b.day;
  }
}

class _DateHeader extends StatelessWidget {
  final DateTime date;

  const _DateHeader({
    required this.date,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 16,
        bottom: 8,
      ),
      child: Text(
        '${date.year}-${date.month}-${date.day}',
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.bold
        ),
      ),
    );
  }
}

class JournalCell extends StatelessWidget {
  final FocusRecord record;

  const JournalCell({
    super.key,
    required this.record,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 96,
      margin: const EdgeInsets.only(
        bottom: 12,
      ),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        children: [
          _buildIcon(context),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  '${_time(record.startTime)} - '
                  '${_time(record.endTime ?? record.startTime)}',
                  style: const TextStyle(
                    fontSize: 12,
                  ),
                ),
                const SizedBox(height: 6),
                Row(
                  children: [
                    Icon(
                      record.isCountdown
                          ? Icons.hourglass_bottom_outlined
                          : Icons.play_circle_outline,
                      size: 12,
                    ),
                    Text(
                      '${Duration(seconds: record.actualSeconds).mmss}  ',
                      style: const TextStyle(
                        fontSize: 12,
                      ),
                    ),
                    const SizedBox(width: 8),
                    _buildTag(context),
                    const SizedBox(width: 8),
                    if (record.note != null && record.note!.isNotEmpty) ...[
                      const SizedBox(height: 6),
                      Expanded(
                        child: Text(
                          record.note!,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 10,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTag(BuildContext context) {
    return Consumer<TagProvider>(
      builder: (_, provider, __) {
        final tag = provider.getById(record.tagId);

        if (tag == null) {
          return const SizedBox();
        }

        return Row(
          children: [
            Container(
              width: 8,
              height: 8,
              decoration: BoxDecoration(
                color: Color(tag.color),
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
            Text(
              tag.name,
              style: const TextStyle(
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildIcon(BuildContext context) {
    final provider = context.read<CollectibleProvider>();

    final item = provider.getById(
      record.collectibleItemId,
    );

    return Container(
      width: 56,
      height: 56,
      decoration: BoxDecoration(
        color: const Color(0xffF6F1E5),
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(4),
      child: Image.asset(
        record.completed ? item.assetPath : "assets/plant_1.png",
        fit: BoxFit.contain,
        filterQuality: FilterQuality.none,
      ),
    );
  }

  String _time(DateTime time) {
    return '${time.hour.toString().padLeft(2, '0')}:'
        '${time.minute.toString().padLeft(2, '0')}';
  }
}
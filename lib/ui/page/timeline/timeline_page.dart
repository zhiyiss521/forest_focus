import 'package:flutter/material.dart';
import 'package:forest_focus/ui/page/timeline/timeline_provider.dart';
import 'package:forest_focus/util/extension.dart';
import 'package:provider/provider.dart';

import '../../../model/FocusRecord.dart';

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
      backgroundColor: const Color(0xFFF5EEDC),

      appBar: AppBar(
        centerTitle: true,
        backgroundColor: const Color(0xFFD8B17A),
        title: const Text('🌳 森林日记'),
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

          final showDateHeader =
              index == 0 ||
                  !_isSameDay(
                    provider.records[index - 1].createdAt,
                    record.createdAt,
                  );

          return Column(
            crossAxisAlignment:
            CrossAxisAlignment.start,
            children: [

              if (showDateHeader)
                _DateHeader(
                  date: record.createdAt,
                ),

              JournalCell(
                record: record,
              ),
            ],
          );
        },
      ),
    );
  }

  bool _isSameDay(
      DateTime a,
      DateTime b,
      ) {
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
        top: 24,
        bottom: 12,
      ),
      child: Text(
        _title(),
        style: const TextStyle(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: Color(0xFF5D4037),
        ),
      ),
    );
  }

  String _title() {

    final now = DateTime.now();

    if (date.year == now.year &&
        date.month == now.month &&
        date.day == now.day) {
      return '☀️ 今天';
    }

    final yesterday =
    now.subtract(const Duration(days: 1));

    if (date.year == yesterday.year &&
        date.month == yesterday.month &&
        date.day == yesterday.day) {
      return '🌙 昨天';
    }

    return '${date.year}-${date.month}-${date.day}';
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
      margin: const EdgeInsets.only(
        bottom: 12,
      ),

      padding: const EdgeInsets.all(16),

      decoration: BoxDecoration(

        color: const Color(0xFFF8F1E7),

        borderRadius:
        BorderRadius.circular(24),

        border: Border.all(
          color: const Color(0xFFD9C2A3),
          width: 2,
        ),
      ),

      child: Row(
        crossAxisAlignment:
        CrossAxisAlignment.start,
        children: [

          Text(
            _emoji(),
            style: const TextStyle(
              fontSize: 36,
            ),
          ),

          const SizedBox(width: 16),

          Expanded(
            child: Column(
              crossAxisAlignment:
              CrossAxisAlignment.start,
              children: [

                Text(
                  _title(),
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight:
                    FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 8),

                Text(
                  '持续 ${Duration(seconds: record.actualSeconds).mmss}',
                ),

                const SizedBox(height: 4),

                Text(
                  '${_time(record.startTime)} - ${_time(record.endTime!)}',
                  style: TextStyle(
                    color: Colors.grey.shade600,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _emoji() {

    if (!record.completed) {
      return '🥀';
    }

    final m =
        record.actualSeconds ~/ 60;

    if (m < 20) return '🌱';
    if (m < 40) return '🌿';
    if (m < 60) return '🌳';

    return '🌲';
  }

  String _title() {

    if (!record.completed) {
      return '幼苗枯萎了';
    }

    final m =
        record.actualSeconds ~/ 60;

    if (m < 20) {
      return '种子发芽';
    }

    if (m < 40) {
      return '灌木成长';
    }

    if (m < 60) {
      return '小树长高';
    }

    return '橡树成熟';
  }

  String _time(DateTime time) {

    return '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';
  }
}


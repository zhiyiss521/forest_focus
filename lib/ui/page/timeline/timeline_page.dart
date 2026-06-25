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
      appBar: AppBar(
        title: const Text('Growth Timeline'),
      ),
      body: provider.loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: provider.records.length,
        itemBuilder: (context, index) {
          final record = provider.records[index];

          return TimelineCell(
            record: record,
            isLast: index == provider.records.length - 1,
          );
        },
      ),
    );
  }
}

class TimelineCell extends StatelessWidget {
  final FocusRecord record;
  final bool isLast;

  const TimelineCell({
    required this.record,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [

          SizedBox(
            width: 60,
            child: Column(
              children: [

                Text(
                  _emoji(record.actualSeconds),
                  style: const TextStyle(fontSize: 30),
                ),

                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: Colors.grey.shade300,
                    ),
                  ),
              ],
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Card(
              elevation: 2,
              margin: const EdgeInsets.only(
                bottom: 24,
              ),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [

                    Text(
                      Duration(seconds: record.actualSeconds).mmss,
                      style: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      _formatDate(record.createdAt),
                    ),

                    const SizedBox(height: 4),

                    Text(
                      '${_formatTime(record.startTime)}'
                          ' - '
                          '${_formatTime(record.endTime)}',
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  String _emoji(int seconds) {
    final minutes = seconds ~/ 60;

    if (minutes < 20) return '🌱';
    if (minutes < 40) return '🌿';
    if (minutes < 60) return '🌳';
    return '🌲';
  }

  String _formatDate(DateTime date) {
    return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')}';
  }

  String _formatTime(DateTime date) {
    return '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
  }
}

import 'package:flutter/material.dart';
import 'package:forest_focus/ui/page/sta/sta_card.dart';
import 'package:forest_focus/ui/page/sta/sta_provider.dart';
import 'package:provider/provider.dart';

class SummaryCard extends StatelessWidget {
  const SummaryCard({super.key});

  @override
  Widget build(BuildContext context) {
    final totalSeconds = context.select<StaProvider, int>(
          (p) => p.totalSeconds,
    );

    final completed = context.select<StaProvider, int>(
          (p) => p.completedCount,
    );

    final failed = context.select<StaProvider, int>(
          (p) => p.failedCount,
    );

    final average = context.select<StaProvider, int>(
          (p) => p.averageSeconds,
    );

    return StaCard(
      title: "Summary",
      child: GridView.count(
        crossAxisCount: 2,
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
        childAspectRatio: 2.2,
        children: [
          _SummaryItem(
            icon: Icons.timer_outlined,
            title: "Focus Time",
            value: _formatDuration(totalSeconds),
            color: Colors.green,
          ),
          _SummaryItem(
            icon: Icons.check_circle_outline,
            title: "Completed",
            value: "$completed",
            color: Colors.blue,
          ),
          _SummaryItem(
            icon: Icons.cancel_outlined,
            title: "Failed",
            value: "$failed",
            color: Colors.red,
          ),
          _SummaryItem(
            icon: Icons.schedule_outlined,
            title: "Average",
            value: _formatDuration(average),
            color: Colors.orange,
          ),
        ],
      ),
    );
  }

  String _formatDuration(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;

    if (h == 0) {
      return "${m}m";
    }

    return "${h}h ${m}m";
  }
}

class _SummaryItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final Color color;

  const _SummaryItem({
    required this.icon,
    required this.title,
    required this.value,
    required this.color,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 20,
            backgroundColor: color.withOpacity(0.15),
            child: Icon(
              icon,
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  value,
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 12,
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
}
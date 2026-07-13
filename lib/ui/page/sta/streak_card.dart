import 'package:flutter/material.dart';
import 'package:forest_focus/ui/page/sta/sta_card.dart';
import 'package:forest_focus/ui/page/sta/sta_provider.dart';
import 'package:provider/provider.dart';

class StreakCard extends StatelessWidget {
  const StreakCard({super.key});

  @override
  Widget build(BuildContext context) {
    final current = context.select<StaProvider, int>(
          (p) => p.currentStreak,
    );

    final best = context.select<StaProvider, int>(
          (p) => p.bestStreak,
    );

    return StaCard(
      title: "Streak",
      child: Row(
        children: [
          Expanded(
            child: _StreakItem(
              icon: Icons.local_fire_department,
              iconColor: Colors.deepOrange,
              title: "Current",
              value: "$current",
              unit: "Days",
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: _StreakItem(
              icon: Icons.emoji_events_outlined,
              iconColor: Colors.amber,
              title: "Best",
              value: "$best",
              unit: "Days",
            ),
          ),
        ],
      ),
    );
  }
}

class _StreakItem extends StatelessWidget {
  final IconData icon;
  final Color iconColor;
  final String title;
  final String value;
  final String unit;

  const _StreakItem({
    required this.icon,
    required this.iconColor,
    required this.title,
    required this.value,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: iconColor.withOpacity(0.08),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Column(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: iconColor.withOpacity(0.15),
            child: Icon(
              icon,
              color: iconColor,
              size: 24,
            ),
          ),
          const SizedBox(height: 12),
          Text(
            value,
            style: const TextStyle(
              fontSize: 26,
              fontWeight: FontWeight.bold,
            ),
          ),
          Text(
            unit,
            style: TextStyle(
              color: Colors.grey.shade600,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            title,
            style: const TextStyle(
              fontWeight: FontWeight.w600,
            ),
          ),
        ],
      ),
    );
  }
}
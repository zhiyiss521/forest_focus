import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:forest_focus/ui/page/sta/sta_card.dart';

class FocusChartCard extends StatelessWidget {
  final String title;
  final int totalSeconds;
  final List<int> chartData;
  final List<String> labels;
  final Color? barColor;

  const FocusChartCard({
    super.key,
    this.title = "Focus Time",
    required this.totalSeconds,
    required this.chartData,
    required this.labels,
    this.barColor,
  });

  @override
  Widget build(BuildContext context) {
    return StaCard(
      title: title,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _formatTime(totalSeconds),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: BarChart(
              _buildChart(context),
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeOut,
            ),
          ),
        ],
      ),
    );
  }

  BarChartData _buildChart(BuildContext context) {
    final color = barColor ?? Theme.of(context).colorScheme.primary;

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      borderData: FlBorderData(show: false),
      gridData: const FlGridData(
        drawVerticalLine: false,
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 36,
            getTitlesWidget: (value, _) {
              return Text(
                _formatAxis(value),
                style: const TextStyle(
                  fontSize: 10,
                  color: Colors.grey,
                ),
              );
            },
          ),
        ),
        bottomTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 28,
            getTitlesWidget: (value, _) {
              final index = value.toInt();

              if (index < 0 || index >= labels.length) {
                return const SizedBox();
              }

              return Padding(
                padding: const EdgeInsets.only(top: 8),
                child: Text(
                  labels[index],
                  style: const TextStyle(
                    fontSize: 11,
                  ),
                ),
              );
            },
          ),
        ),
      ),
      barTouchData: BarTouchData(
        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (_, __, rod, ___) {
            return BarTooltipItem(
              _formatTime(
                rod.toY.toInt(),
              ),
              const TextStyle(
                color: Colors.white,
                fontSize: 12,
              ),
            );
          },
        ),
      ),
      barGroups: List.generate(
        chartData.length,
            (index) {
          return BarChartGroupData(
            x: index,
            barRods: [
              BarChartRodData(
                toY: chartData[index].toDouble(),
                width: _barWidth(),
                color: color,
                borderRadius: BorderRadius.circular(6),
              ),
            ],
          );
        },
      ),
    );
  }

  double _barWidth() {
    if (chartData.length <= 7) {
      return 24;
    }

    if (chartData.length <= 31) {
      return 10;
    }

    return 6;
  }

  String _formatTime(int seconds) {
    final h = seconds ~/ 3600;
    final m = seconds % 3600 ~/ 60;

    if (h > 0) {
      return "${h}h ${m}m";
    }

    return "${m}m";
  }

  String _formatAxis(double value) {
    final seconds = value.toInt();
    final h = seconds ~/ 3600;
    final m = seconds % 3600 ~/ 60;

    if (h > 0) {
      return "${h}h";
    }

    if (m > 0) {
      return "${m}m";
    }

    return "0";
  }
}
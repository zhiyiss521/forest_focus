import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:forest_focus/ui/page/sta/sta_card.dart';
import 'package:forest_focus/ui/page/sta/sta_provider.dart';
import 'package:provider/provider.dart';
import '../../../model/sta_range.dart';

class FocusChartCard extends StatelessWidget {
  const FocusChartCard({super.key});

  @override
  Widget build(BuildContext context) {
    //
    final totalSeconds = context.select<StaProvider, int>((p) => p.totalSeconds);
    final chart = context.select<StaProvider, List<int>>((p) => p.chartData);
    final range = context.select<StaProvider, StaRange>((p) => p.range);

    return StaCard(
      title: "Focus Time",
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            _time(totalSeconds),
            style: const TextStyle(
              fontSize: 28,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 24),
          SizedBox(
            height: 220,
            child: LayoutBuilder(
              builder: (context, constraints) {
                final chartWidth = constraints.maxWidth;
                return BarChart(
                  _buildChart(context, chart, range,chartWidth),
                  duration: const Duration(milliseconds: 600),
                  curve: Curves.easeOutCubic,
                );
              }
            ),
          ),
        ],
      ),
    );
  }

  String _time(int second) {
    final h = second ~/ 3600;
    final m = (second % 3600) ~/ 60;

    if (h == 0) {
      return "${m}m";
    }

    return "${h}h ${m}m";
  }

  BarChartData _buildChart( BuildContext context, List<int> data, StaRange range,double width) {
    final barWidth = _barWidth(width, data.length);

    return BarChartData(
      alignment: BarChartAlignment.spaceAround,
      borderData: FlBorderData(show: false),
      gridData: FlGridData(
        drawVerticalLine: false,
      ),
      titlesData: FlTitlesData(
        topTitles: const AxisTitles(),
        rightTitles: const AxisTitles(),
        leftTitles: AxisTitles(
          sideTitles: SideTitles(
            showTitles: true,
            reservedSize: 40,
            getTitlesWidget: (value, meta) {
              return Text(
                _formatYAxis(value),
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
            getTitlesWidget: (value, meta) {
              final index = value.toInt();
              return xAxisWidget(index, data, range,width);
            },
          ),
        ),
      ),
      barTouchData: BarTouchData(
        enabled: true,

        touchTooltipData: BarTouchTooltipData(
          getTooltipItem: (
              BarChartGroupData group,
              int groupIndex,
              BarChartRodData rod,
              int rodIndex,
              ) {
            final seconds = rod.toY.toInt();

            return BarTooltipItem(
              _formatTooltip(seconds),
              const TextStyle(
                color: Colors.white,
                fontSize: 12,
                fontWeight: FontWeight.bold,
              ),
            );
          },
        ),
      ),
      barGroups: List.generate(data.length, (index) {
        return BarChartGroupData(
          x: index,
          barRods: [
            BarChartRodData(
              toY: data[index].toDouble(),
              width: barWidth,
              borderRadius: BorderRadius.circular(6),
            ),
          ],
        );
      }),
    );
  }

  String _formatTooltip(int seconds) {
    final h = seconds ~/ 3600;
    final m = (seconds % 3600) ~/ 60;

    if (h > 0) {
      return "${h}h ${m}m";
    }

    return "${m}m";
  }

  String _formatYAxis(double value) {
    final seconds = value.toInt();

    final hour = seconds ~/ 3600;
    final minute = (seconds % 3600) ~/ 60;

    if (hour > 0) {
      return "${hour}h";
    }

    if (minute > 0) {
      return "${minute}m";
    }

    return "0";
  }

  Widget xAxisWidget(int index, List<int> data, StaRange range, double chartWidth) {
    if (index < 0 || index >= data.length) {
      return const SizedBox();
    }

    final step = _xAxisStep(
      chartWidth,
      data.length,
      range,
    );

    // 不需要显示的隐藏
    if (index % step != 0) {
      return const SizedBox();
    }

    return Padding(
      padding: const EdgeInsets.only(top: 8),
      child: Text(
        _label(index, range),
        style: const TextStyle(
          fontSize: 11,
        ),
      ),
    );
  }

  int _xAxisStep(double width, int count, StaRange range,) {
    switch (range) {

    // 24小时
      case StaRange.day:
        if (width >= 400) {
          return 2; // 0 2 4 6...
        }

        if (width >= 320) {
          return 3; // 0 3 6 9...
        }

        return 4;

    // 一周
      case StaRange.week:
        return 1;

    // 一个月
      case StaRange.month:
        final maxCount = (width / 35).floor();

        if (count <= maxCount) {
          return 1;
        }

        return (count / maxCount).ceil();

      case StaRange.year:
        if (width >= 400) {
          return 1;
        }

        return 2;
    }
  }

  double _barWidth(double chartWidth, int count) {
    // 每个柱子所占的空间
    final itemWidth = chartWidth / count;

    // 柱子占 60%，剩余留给间距
    final width = itemWidth * 0.6;

    // 限制最小最大宽度
    return width.clamp(4.0, 28.0);
  }

  String _label(int index, StaRange range) {
    switch (range) {
      case StaRange.day:
        return "${index.toString().padLeft(2, '0')}:00";
      case StaRange.week:
        const text = [
          "M",
          "T",
          "W",
          "T",
          "F",
          "S",
          "S",
        ];
        return text[index];
      case StaRange.month:
        return "${index + 1}";
      case StaRange.year:
        const months = [
          "Jan",
          "Feb",
          "Mar",
          "Apr",
          "May",
          "Jun",
          "Jul",
          "Aug",
          "Sep",
          "Oct",
          "Nov",
          "Dec",
        ];
        return months[index];
    }
  }
}
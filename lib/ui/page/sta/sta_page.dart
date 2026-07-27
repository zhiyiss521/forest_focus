import 'package:flutter/material.dart';
import 'package:forest_focus/ui/page/sta/reward_card.dart';
import 'package:provider/provider.dart';
import '../../../model/sta_range.dart';
import '../../widget/ff_date_navigator.dart';
import '../../widget/ff_segment_button.dart';
import 'focus_chart_card.dart';
import 'sta_provider.dart';

class StaPage extends StatelessWidget {
  const StaPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => StaProvider()..load(),
      child: const _StaView(),
    );
  }
}

class _StaView extends StatelessWidget {
  const _StaView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<StaProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text("My Forest"),
      ),
      body: provider.loading
          ? const Center(
        child: CircularProgressIndicator(),
      )
          : RefreshIndicator(
        onRefresh: provider.load,
        child: ListView(
          padding: const EdgeInsets.all(16),
          children: [
            FFSegmentButton<StaRange>(
              items: const [
                FFSegmentItem(
                  title: "Day",
                  value: StaRange.day,
                ),
                FFSegmentItem(
                  title: "Week",
                  value: StaRange.week,
                ),
                FFSegmentItem(
                  title: "Month",
                  value: StaRange.month,
                ),
                FFSegmentItem(
                  title: "Year",
                  value: StaRange.year,
                ),
              ],
              selected: provider.currentRange,
              onChanged: provider.changeRange,
            ),

            FFDateNavigator(
              title: provider.dateTitle,
              onPrevious: provider.previous,
              onNext: provider.next,
            ),

            RewardCard(),

            FocusChartCard(
              totalSeconds: provider.totalSeconds,
              chartData: provider.chartData,
              labels: provider.chartLabels,
            )
          ],
        ),
      ),
    );
  }
}
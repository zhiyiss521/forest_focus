import 'package:flutter/material.dart';
import 'package:forest_focus/ui/page/sta/reward_card.dart';
import 'package:forest_focus/ui/page/sta/sta_date_header.dart';
import 'package:forest_focus/ui/page/sta/sta_range_header.dart';
import 'package:forest_focus/ui/page/sta/streak_card.dart';
import 'package:forest_focus/ui/page/sta/summary_card.dart';
import 'package:provider/provider.dart';
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
          children: const [
            StaRangeHeader(),

            SizedBox(height: 12),

            StaDateHeader(),

            SizedBox(height: 16),

            RewardCard(),

            SizedBox(height: 16),

            FocusChartCard(),

            SizedBox(height: 16),

            // SummaryCard(),

            SizedBox(height: 16),

            StreakCard(),

            SizedBox(height: 32),
          ],
        ),
      ),
    );
  }
}
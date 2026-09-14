import 'package:flutter/material.dart';
import 'package:forest_focus/core/model/sta_range.dart';
import 'package:forest_focus/ui/page/sta/reward_card.dart';
import 'package:provider/provider.dart';
import '../../widget/ff_date_navigator.dart';
import '../../widget/ff_segment_button.dart';
import '../../widget/ff_tag_select_dialog.dart';
import '../tag/tag_provider.dart';
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
    final tagProvider = context.watch<TagProvider>();

    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: FilterButton(
          title: provider.tagTitle,
          onTap: () {
            FFTagSelectDialog.show(
              context,
              tags: tagProvider.items,
              selectedTags: provider.currentTags,
              onConfirm: (tags) {
                provider.changeTags(tags);
              },
            );
          },
        ),
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

class FilterButton extends StatelessWidget {
  final String title;
  final VoidCallback onTap;

  const FilterButton({
    super.key,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        height: 36,
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
        ),
        decoration: BoxDecoration(
          color: Colors.white24,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              title,
              style: const TextStyle(
                fontSize: 14,
              ),
            ),
            const SizedBox(width: 2),
            const Icon(
              Icons.keyboard_arrow_down,
              size: 18,
            ),
          ],
        ),
      ),
    );
  }
}
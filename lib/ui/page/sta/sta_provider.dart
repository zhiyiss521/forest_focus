import 'package:flutter/material.dart';
import 'package:forest_focus/core/model/collectible_item.dart';
import 'package:forest_focus/core/model/focus_record.dart';
import 'package:forest_focus/core/model/sta_range.dart';
import 'package:forest_focus/core/model/tag.dart';
import '../../../core/repository/collectible_repository.dart';
import '../../../core/repository/focus_record_repository.dart';
import '../../../core/repository/tag_repository.dart';

class StaProvider extends ChangeNotifier {
  final _recordRepository = FocusRecordRepository.instance;
  final _collectibleRepository = CollectibleRepository.instance;
  final _tagRepository = TagRepository.instance;

  bool loading = true;

  StaRange currentRange = StaRange.week;
  DateTime currentDate = DateTime.now();

  List<Tag> currentTags = [];

  List<FocusRecord> records = [];
  List<CollectibleItem> rewards = [];

  int totalSeconds = 0;

  List<int> chartData = [];
  List<String> chartLabels = [];

  Future<void> load() async {
    loading = true;
    notifyListeners();

    await _loadTags();
    await loadData();

    loading = false;
    notifyListeners();
  }

  Future<void> loadData() async {
    records = await _recordRepository.findByDateRange(
      start: startDate,
      end: endDate,
      tagIds: currentTags.isEmpty
          ? null
          : currentTags
          .map((e) => e.id)
          .whereType<int>()
          .toList(),
    );

    _buildStatistics();

    await _loadRewards();
  }


  Future<void> _loadTags() async {
    currentTags = await _tagRepository.findAll();
  }

  void _buildStatistics() {
    totalSeconds = records.fold(
      0,
          (sum, item) => sum + item.actualSeconds,
    );

    chartData = _buildChartData();
    chartLabels = _buildChartLabels();
  }

  Future<void> _refresh() async {
    loading = true;
    notifyListeners();

    await loadData();

    loading = false;
    notifyListeners();
  }

  Future<void> _loadRewards() async {
    final ids = records
        .map((e) => e.collectibleItemId)
        .whereType<int>()
        .toSet();

    rewards = await _collectibleRepository.findByIds(ids);
  }

  List<int> _buildChartData() {
    switch (currentRange) {
      case StaRange.day:
        return List.generate(
          24, (index) {
            return _secondsOf(
              records.where(
                    (e) => e.startTime.hour == index,
              ),
            );
          },
        );

      case StaRange.week:
        return List.generate(
          7, (index) {
            return _secondsOf(records.where((e) => e.startTime.weekday == index + 1,),);
          },
        );

      case StaRange.month:
        final days = DateTime(
          currentDate.year,
          currentDate.month + 1,
          0,
        ).day;

        return List.generate(
          days,
              (index) {
            return _secondsOf(
              records.where(
                    (e) => e.startTime.day == index + 1,
              ),
            );
          },
        );

      case StaRange.year:
        return List.generate(
          12,
              (index) {
            return _secondsOf(
              records.where(
                    (e) => e.startTime.month == index + 1,
              ),
            );
          },
        );
    }
  }

  int _secondsOf(Iterable<FocusRecord> list) {
    return list.fold(0, (sum, item) => sum + item.actualSeconds,);
  }

  List<String> _buildChartLabels() {
    switch (currentRange) {
      case StaRange.day:
        return List.generate(
          24,
              (i) => "${i.toString().padLeft(2, '0')}:00",
        );

      case StaRange.week:
        return const [
          "M",
          "T",
          "W",
          "T",
          "F",
          "S",
          "S",
        ];

      case StaRange.month:
        final days = DateTime(
          currentDate.year,
          currentDate.month + 1,
          0,
        ).day;

        return List.generate(
          days,
              (i) => "${i + 1}",
        );

      case StaRange.year:
        return const [
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
    }
  }

  String _two(int value) {
    return value.toString().padLeft(2, '0');
  }
}

extension Func on StaProvider{
  Future<void> changeTags(List<Tag> tags) async {
    currentTags = tags;

    await _refresh();
  }

  Future<void> clearTags() async {
    currentTags.clear();

    await _refresh();
  }

  Future<void> changeRange(StaRange value) async {
    if (currentRange == value) {
      return;
    }

    currentRange = value;

    await _refresh();
  }

  Future<void> previous() async {
    switch (currentRange) {
      case StaRange.day:
        currentDate = currentDate.subtract(
          const Duration(days: 1),
        );
        break;

      case StaRange.week:
        currentDate = currentDate.subtract(
          const Duration(days: 7),
        );
        break;

      case StaRange.month:
        currentDate = DateTime(
          currentDate.year,
          currentDate.month - 1,
          1,
        );
        break;

      case StaRange.year:
        currentDate = DateTime(
          currentDate.year - 1,
          1,
          1,
        );
        break;
    }

    await _refresh();
  }

  Future<void> next() async {
    switch (currentRange) {
      case StaRange.day:
        currentDate = currentDate.add(
          const Duration(days: 1),
        );
        break;

      case StaRange.week:
        currentDate = currentDate.add(
          const Duration(days: 7),
        );
        break;

      case StaRange.month:
        currentDate = DateTime(
          currentDate.year,
          currentDate.month + 1,
          1,
        );
        break;

      case StaRange.year:
        currentDate = DateTime(
          currentDate.year + 1,
          1,
          1,
        );
        break;
    }

    await _refresh();
  }
}

extension Get on StaProvider{

  String get tagTitle {
    if (currentTags.isEmpty) {
      return "All Tags";
    }

    if (currentTags.length == 1) {
      return currentTags.first.name;
    }

    return "${currentTags.length} Tags";
  }

  DateTime get startDate {
    switch (currentRange) {
      case StaRange.day:
        return DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
        );

      case StaRange.week:
        final day = DateTime(
          currentDate.year,
          currentDate.month,
          currentDate.day,
        );

        return day.subtract(
          Duration(days: day.weekday - 1),
        );

      case StaRange.month:
        return DateTime(
          currentDate.year,
          currentDate.month,
          1,
        );

      case StaRange.year:
        return DateTime(
          currentDate.year,
          1,
          1,
        );
    }
  }

  DateTime get endDate {
    switch (currentRange) {
      case StaRange.day:
        return startDate.add(
          const Duration(days: 1),
        );

      case StaRange.week:
        return startDate.add(
          const Duration(days: 7),
        );

      case StaRange.month:
        return DateTime(
          currentDate.year,
          currentDate.month + 1,
          1,
        );

      case StaRange.year:
        return DateTime(
          currentDate.year + 1,
          1,
          1,
        );
    }
  }

  String get dateTitle {
    switch (currentRange) {
      case StaRange.day:
        return "${currentDate.year}-${_two(currentDate.month)}-${_two(currentDate.day)}";

      case StaRange.week:
        final end = endDate.subtract(
          const Duration(days: 1),
        );

        return "${_two(startDate.month)}/${_two(startDate.day)} - ${_two(end.month)}/${_two(end.day)}";

      case StaRange.month:
        return "${currentDate.year}-${_two(currentDate.month)}";

      case StaRange.year:
        return "${currentDate.year}";
    }
  }
}
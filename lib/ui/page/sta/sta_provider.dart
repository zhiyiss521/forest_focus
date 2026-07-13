import 'package:flutter/material.dart';

import '../../../core/repository/FocusRecordRepository.dart';
import '../../../core/repository/collectible_repository.dart';
import '../../../model/CollectibleItem.dart';
import '../../../model/FocusRecord.dart';
import '../../../model/sta_range.dart';

class StaProvider extends ChangeNotifier {
  final _recordRepository = FocusRecordRepository();

  final _collectibleRepository = CollectibleRepository.instance;

  bool loading = true;

  StaRange range = StaRange.week;

  DateTime selectedDate = DateTime.now();

  List<FocusRecord> currentRecords = [];

  List<CollectibleItem> rewards = [];

  int totalSeconds = 0;

  int completedCount = 0;

  int failedCount = 0;

  int averageSeconds = 0;

  double completionRate = 0;

  int currentStreak = 0;

  int bestStreak = 0;

  List<int> chartData = [];

  Future<void> load() async {
    loading = true;
    notifyListeners();

    await reloadData();

    loading = false;
    notifyListeners();
  }

  Future<void> reloadData() async {
    currentRecords = await _recordRepository.findByDateRange(
      start: _startDate,
      end: _endDate,
    );

    totalSeconds = await _recordRepository.getTotalFocusSeconds(
      start:_startDate,
      end:_endDate
    );

    completedCount = await _recordRepository.getCompletedCount();

    failedCount = await _recordRepository.getFailedCount();

    averageSeconds = await _recordRepository.getAverageFocusSeconds();

    completionRate = await _recordRepository.getCompletionRate();

    chartData = await _recordRepository.getChartData(
      range,
      selectedDate,
    );

    await _loadRewards();
  }

  Future<void> changeRange( StaRange value,) async {
    if (range == value) {
      return;
    }

    range = value;

    loading = true;
    notifyListeners();

    await reloadData();

    loading = false;
    notifyListeners();
  }

  Future<void> previous() async {
    switch (range) {
      case StaRange.day:
        selectedDate = selectedDate.subtract(
          const Duration(days: 1),
        );
        break;

      case StaRange.week:
        selectedDate = selectedDate.subtract(
          const Duration(days: 7),
        );
        break;

      case StaRange.month:
        selectedDate = DateTime(
          selectedDate.year,
          selectedDate.month - 1,
          1,
        );
        break;

      case StaRange.year:
        selectedDate = DateTime(
          selectedDate.year - 1,
          1,
          1,
        );
        break;
    }

    loading = true;
    notifyListeners();

    await reloadData();

    loading = false;
    notifyListeners();
  }

  Future<void> next() async {
    switch (range) {
      case StaRange.day:
        selectedDate = selectedDate.add(
          const Duration(days: 1),
        );
        break;

      case StaRange.week:
        selectedDate = selectedDate.add(
          const Duration(days: 7),
        );
        break;

      case StaRange.month:
        selectedDate = DateTime(
          selectedDate.year,
          selectedDate.month + 1,
          1,
        );
        break;

      case StaRange.year:
        selectedDate = DateTime(
          selectedDate.year + 1,
          1,
          1,
        );
        break;
    }

    loading = true;
    notifyListeners();

    await reloadData();

    loading = false;
    notifyListeners();
  }

  Future<void> _loadRewards() async {
    rewards.clear();

    final ids = currentRecords
        .map((e) => e.rewardId)
        .whereType<String>()
        .toSet();

    rewards.addAll(
      await _collectibleRepository.findByIds(ids),
    );
  }

  DateTime get _startDate {
    switch (range) {
      case StaRange.day:
        return DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        );

      case StaRange.week:
        final day = DateTime(
          selectedDate.year,
          selectedDate.month,
          selectedDate.day,
        );
        return day.subtract(
          Duration(days: day.weekday - 1),
        );

      case StaRange.month:
        return DateTime(
          selectedDate.year,
          selectedDate.month,
          1,
        );

      case StaRange.year:
        return DateTime(
          selectedDate.year,
          1,
          1,
        );
    }
  }

  DateTime get _endDate {
    switch (range) {
      case StaRange.day:
        return _startDate.add(const Duration(days: 1));

      case StaRange.week:
        return _startDate.add(const Duration(days: 7));

      case StaRange.month:
        return DateTime(
          selectedDate.year,
          selectedDate.month + 1,
          1,
        );

      case StaRange.year:
        return DateTime(
          selectedDate.year + 1,
          1,
          1,
        );
    }
  }

  String get rangeTitle {
    switch (range) {
      case StaRange.day:
        return "Day";
      case StaRange.week:
        return "Week";
      case StaRange.month:
        return "Month";
      case StaRange.year:
        return "Year";
    }
  }

  String get dateTitle {
    switch (range) {
      case StaRange.day:
        return "${selectedDate.year}-${_two(selectedDate.month)}-${_two(selectedDate.day)}";

      case StaRange.week:
        final start = _startDate;
        final end = _endDate.subtract(const Duration(days: 1));

        return "${_two(start.month)}/${_two(start.day)} - ${_two(end.month)}/${_two(end.day)}";

      case StaRange.month:
        return "${selectedDate.year}-${_two(selectedDate.month)}";

      case StaRange.year:
        return "${selectedDate.year}";
    }
  }

  String _two(int value) {
    return value.toString().padLeft(2, '0');
  }
}
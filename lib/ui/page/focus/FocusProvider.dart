import 'dart:async';

import 'package:flutter/material.dart';
import '../../../core/repository/FocusRecordRepository.dart';
import '../../../core/repository/focus_session_repository.dart';
import '../../../model/FocusRecord.dart';
import '../../../model/FocusState.dart';
import '../../../model/collectible_item.dart';

class FocusProvider extends ChangeNotifier {
  Duration userSetDuration = const Duration(minutes: 10);
  String totalMinute = "";
  FocusState state = FocusState.setting;
  Duration pausedRemaining = Duration.zero;
  DateTime? startTime;
  DateTime? scheduleEndTime;
  int? currentRecordId;
  int selectedRewardId = 2;

  Timer? _ticker;

  final _recordRepository = FocusRecordRepository();

  final _sessionRepository = FocusSessionRepository.instance;

  FocusProvider() {
    loadSession();
    startTimer();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> loadSession() async {
    final FocusSession session =
    await _sessionRepository.load();

    state = session.state;
    userSetDuration = session.userSetDuration;
    pausedRemaining = session.pausedRemaining;
    startTime = session.startTime;
    scheduleEndTime = session.scheduleEndTime;
    currentRecordId = session.currentRecordId;
    selectedRewardId = session.selectedRewardId;

    await checkPageState();
    await loadTotalMinute();

    notifyListeners();
  }

  Future<void> saveSession() async {
    await _sessionRepository.save(
      FocusSession(
        state: state,
        userSetDuration: userSetDuration,
        pausedRemaining: pausedRemaining,
        startTime: startTime,
        scheduleEndTime: scheduleEndTime,
        currentRecordId: currentRecordId,
        selectedRewardId: selectedRewardId,
      ),
    );
  }

  Future<void> loadTotalMinute() async {
    final totalSeconds =
    await _recordRepository.getTotalFocusSeconds();

    totalMinute = formatTotalFocusTime(totalSeconds);

    notifyListeners();
  }

  Future<void> checkPageState() async {
    if (state != FocusState.running) {
      return;
    }

    if (scheduleEndTime == null) {
      return;
    }

    if (DateTime.now().isAfter(scheduleEndTime!)) {
      await finish();
    }
  }

  void startTimer() {
    _ticker?.cancel();

    _ticker = Timer.periodic(
      const Duration(seconds: 1),
          (_) async {
        if (state != FocusState.running) {
          return;
        }

        await checkPageState();

        notifyListeners();
      },
    );
  }

  // MARK: Reward

  void selectReward(CollectibleItem reward) {
    selectedRewardId = reward.id;
    saveSession();

    notifyListeners();
  }

  // MARK: Duration

  Future<void> updateMinutes(int value) async {
    userSetDuration = Duration(minutes: value);

    await saveSession();

    notifyListeners();
  }

  // MARK: Focus

  Future<void> start() async {
    pausedRemaining = Duration.zero;

    startTime = DateTime.now();

    scheduleEndTime = startTime!.add(userSetDuration);

    state = FocusState.running;

    final record = FocusRecord(
      startTime: startTime!,
      endTime: scheduleEndTime!,
      targetSeconds: userSetDuration.inSeconds,
      actualSeconds: 0,
      completed: false,
      rewardId: selectedRewardId,
      createdAt: DateTime.now(),
    );

    currentRecordId =
    await _recordRepository.insert(record);

    await saveSession();

    notifyListeners();
  }

  Future<void> cancel() async {
    if (currentRecordId != null) {
      final record =
      await _recordRepository.findById(currentRecordId!);

      if (record != null) {
        record.endTime = DateTime.now();

        record.actualSeconds =
            userSetDuration.inSeconds - remaining.inSeconds;

        record.completed = false;

        await _recordRepository.update(record);
      }
    }

    currentRecordId = null;

    pausedRemaining = Duration.zero;

    startTime = null;

    scheduleEndTime = null;

    state = FocusState.setting;

    await _sessionRepository.clear();

    notifyListeners();
  }

  Future<void> pause() async {
    pausedRemaining = remaining;

    state = FocusState.paused;

    await saveSession();

    notifyListeners();
  }

  Future<void> resume() async {
    scheduleEndTime =
        DateTime.now().add(pausedRemaining);

    pausedRemaining = Duration.zero;

    state = FocusState.running;

    await saveSession();

    notifyListeners();
  }

  Future<void> finish() async {
    if (state == FocusState.finished) {
      return;
    }

    if (currentRecordId != null) {
      final record =
      await _recordRepository.findById(currentRecordId!);

      if (record != null) {
        record.endTime = DateTime.now();

        record.actualSeconds = userSetDuration.inSeconds;

        record.completed = true;

        await _recordRepository.update(record);
      }
    }

    currentRecordId = null;

    state = FocusState.finished;

    startTime = null;

    scheduleEndTime = null;

    pausedRemaining = Duration.zero;

    await _sessionRepository.clear();

    await loadTotalMinute();

    notifyListeners();
  }

  // MARK: Getter

  Duration get remaining {
    if (state == FocusState.paused) {
      return pausedRemaining;
    }

    if (scheduleEndTime == null) {
      return Duration.zero;
    }

    final diff = scheduleEndTime!.difference(DateTime.now());

    return diff.isNegative ? Duration.zero : diff;
  }

  String formatTotalFocusTime(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);

    final hours = duration.inHours;

    final minutes = duration.inMinutes % 60;

    return '${hours}小时${minutes}分钟';
  }

  double get progress {
    if (state == FocusState.setting) {
      return 0;
    }

    if (state == FocusState.finished) {
      return 1;
    }

    if (userSetDuration.inSeconds == 0) {
      return 0;
    }

    final passed =
        userSetDuration.inSeconds - remaining.inSeconds;

    return (passed / userSetDuration.inSeconds)
        .clamp(0.0, 1.0);
  }

  bool get isRunning => state == FocusState.running;

  bool get isPaused => state == FocusState.paused;

  bool get isFinished => state == FocusState.finished;

  bool get isSetting => state == FocusState.setting;
}
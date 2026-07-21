import 'dart:async';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:forest_focus/core/repository/collectible_repository.dart';
import 'package:forest_focus/core/repository/tag_repository.dart';
import 'package:forest_focus/util/extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/repository/FocusRecordRepository.dart';
import '../../../model/FocusRecord.dart';
import '../../../model/collectible_item.dart';
import '../../../model/FocusState.dart';
import '../../../model/focus_session.dart';
import '../../../model/tag.dart';

class FocusProvider extends ChangeNotifier {

  static const String sessionKey = "focus_session";

  FocusProvider() {}

  String totalMinute = "";// 今天已经专注了多长时间
  Timer? ticker;
  late FocusSession session;

  Future<void> load() async  {
    await loadSession();
    await checkPageState();
    await loadTotalMinute();

    startTimer();
    notifyListeners();
  }

  @override
  void dispose() {
    ticker?.cancel();
    super.dispose();
  }

  // MARK: Timer
  void startTimer() {
    ticker?.cancel();

    ticker = Timer.periodic(
      const Duration(seconds: 1),
          (_) async {
        if (!isRunning) {
          return;
        }

        await checkPageState();

        notifyListeners();
      },
    );
  }

  // MARK: Duration

  Future<void> updateMinutes(int minutes) async {
    session = session.copyWith(
      userSetDuration: Duration(minutes: minutes),
    );

    await saveSession();

    notifyListeners();
  }

  Future<void> loadTotalMinute() async {
    final totalSeconds = await FocusRecordRepository.instance.getTotalFocusSeconds();
    totalMinute = totalSeconds.focusDuration;
    notifyListeners();
  }

  // 恢复或初始化一套默认的数据
  Future<void> loadSession() async {
    final sp = await SharedPreferences.getInstance();
    final json = sp.getString(sessionKey);

    if (json == null) {
      final tags = await TagRepository.instance.findAll();
      final collections = await CollectibleRepository.instance.findAll();
      session = FocusSession(
        currentTagId: tags.first.id!,
        currentCollectibleItemId: collections.first.id
      );
      await saveSession();
    }else{
      session = FocusSession.fromJson(
        jsonDecode(json),
      );
    }
  }

  Future<void> saveSession() async {
    final sp = await SharedPreferences.getInstance();

    await sp.setString(
      FocusProvider.sessionKey,
      jsonEncode(session.toJson()),
    );
  }

  Future<void> clearSession() async {
    final sp = await SharedPreferences.getInstance();

    await sp.remove(
      FocusProvider.sessionKey,
    );
  }

  // MARK: State Check

  Future<void> checkPageState() async {
    if (!isRunning) {
      return;
    }

    if (session.scheduleEndTime == null) {
      return;
    }

    if (DateTime.now().isAfter(
      session.scheduleEndTime!,
    )) {
      await finish();
    }
  }
}

extension FocusProviderGetter on FocusProvider{

  Duration get remaining {
    if (isPaused) {
      return session.pausedRemaining;
    }

    if (session.scheduleEndTime == null) {
      return Duration.zero;
    }

    final diff = session.scheduleEndTime!
        .difference(DateTime.now());

    return diff.isNegative
        ? Duration.zero
        : diff;
  }

  double get progress {
    if (isSetting) {
      return 0;
    }

    if (isFinished) {
      return 1;
    }

    if (session.userSetDuration.inSeconds == 0) {
      return 0;
    }

    final passed = session.userSetDuration.inSeconds - remaining.inSeconds;

    return (passed / session.userSetDuration.inSeconds).clamp(0.0, 1.0);
  }

  Duration get userSetDuration => session.userSetDuration;
  int get currentCollectibleItemId => session.currentCollectibleItemId;
  int get currentTagId => session.currentTagId;

  // MARK: State
  FocusState get state => session.state;
  bool get isRunning => state == FocusState.running;
  bool get isPaused => state == FocusState.paused;
  bool get isFinished => state == FocusState.finished;
  bool get isSetting => state == FocusState.setting;
}

extension FocusProviderAction on FocusProvider {

  Future<void> changeCollectibleItem(int collectibleItemId) async {
    session = session.copyWith(currentCollectibleItemId: collectibleItemId);
    await saveSession();
    notifyListeners();
  }

  Future<void> changeTag(int tagId) async {
    session = session.copyWith(currentTagId: tagId);
    await saveSession();
    notifyListeners();
  }

  Future<void> start() async {
    final now = DateTime.now();

    session = session.copyWith(
      state: FocusState.running,
      pausedRemaining: Duration.zero,
      startTime: now,
      scheduleEndTime: now.add(
        session.userSetDuration,
      ),
      clearCurrentRecordId: true,
    );

    final record = FocusRecord(
      startTime: session.startTime!,
      endTime: session.scheduleEndTime!,
      targetSeconds: session.userSetDuration.inSeconds,
      actualSeconds: 0,
      completed: false,
      rewardId: session.currentCollectibleItemId,
      createdAt: now,
    );

    final id = await FocusRecordRepository.instance.insert(record);

    session = session.copyWith(recordId: id);

    await saveSession();

    notifyListeners();
  }

  Future<void> pause() async {
    session = session.copyWith(
      state: FocusState.paused,
      pausedRemaining: remaining,
    );

    await saveSession();
    notifyListeners();
  }

  Future<void> resume() async {
    session = session.copyWith(
      state: FocusState.running,
      scheduleEndTime: DateTime.now().add(
        session.pausedRemaining,
      ),
      pausedRemaining: Duration.zero,
    );

    await saveSession();
    notifyListeners();
  }

  Future<void> cancel() async {
    if (session.recordId != null) {
      final record = await FocusRecordRepository.instance.findById(
        session.recordId!,
      );

      if (record != null) {
        record.endTime = DateTime.now();

        record.actualSeconds =
            session.userSetDuration.inSeconds -
                remaining.inSeconds;

        record.completed = false;

        await FocusRecordRepository.instance.update(record);
      }
    }

    session = session.copyWith(
      state: FocusState.setting,
      pausedRemaining: Duration.zero,
      clearStartTime: true,
      clearScheduleEndTime: true,
      clearCurrentRecordId: true,
    );

    await clearSession();

    notifyListeners();
  }

  Future<void> finish() async {
    if (isFinished) {
      return;
    }

    if (session.recordId != null) {
      final record = await FocusRecordRepository.instance.findById(
        session.recordId!,
      );

      if (record != null) {
        record.endTime = DateTime.now();

        record.actualSeconds =
            session.userSetDuration.inSeconds;

        record.completed = true;

        await FocusRecordRepository.instance.update(record);
      }
    }

    session = session.copyWith(
      state: FocusState.finished,
      pausedRemaining: Duration.zero,
      clearStartTime: true,
      clearScheduleEndTime: true,
      clearCurrentRecordId: true,
    );

    await clearSession();

    await loadTotalMinute();

    notifyListeners();
  }
}
import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:forest_focus/core/repository/collectible_repository.dart';
import 'package:forest_focus/core/repository/tag_repository.dart';
import 'package:forest_focus/util/extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/repository/focus_record_repository.dart';
import '../../../model/FocusState.dart';
import '../../../model/focus_record.dart';
import '../../../model/focus_session.dart';

class FocusProvider extends ChangeNotifier {

  static const String sessionKey = "focus_session";

  FocusProvider() {}

  String totalMinute = "";// 今天已经专注了多长时间
  Timer? ticker;
  // 1.session加字段，2.数据库model加，3，数据库改
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

  void startTimer() {
    ticker?.cancel();

    ticker = Timer.periodic(
      const Duration(seconds: 1), (_) async {
        if (!isRunning) {
          return;
        }

        await checkPageState();

        notifyListeners();
      },
    );
  }

  Future<void> checkPageState() async {
    if (!isRunning) return;

    if (isCountdown) {
      if (session.scheduleEndTime == null) return;

      if (DateTime.now().isAfter(session.scheduleEndTime!)) {
        await finish();
      }
    } else {
      if (session.startTime == null) return;

      final passed = DateTime.now().difference(session.startTime!);
      if (passed >= const Duration(minutes: AppConstants.maxMinutes)) {
        await finish();
      }
    }
  }
}

extension FocusProviderSession on FocusProvider{

  Future<void> loadTotalMinute() async {
    final totalSeconds = await FocusRecordRepository.instance.getTotalFocusSeconds();
    totalMinute = totalSeconds.focusDuration;
    notifyListeners();
  }

  Future<void> loadSession() async {
    final sp = await SharedPreferences.getInstance();
    final json = sp.getString(FocusProvider.sessionKey);

    if (json == null) {
      final tags = await TagRepository.instance.findAll();
      final collections = await CollectibleRepository.instance.findAll();
      session = FocusSession(
        userSetDuration: Duration(minutes: AppConstants.minMinutes),
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
}

extension FocusProviderGetter on FocusProvider{

  // 还剩下多少时间
  Duration get remaining {
    if (!isCountdown) {
      return Duration.zero;
    }
    if (isPaused) {
      return session.pausedRemaining;
    }
    if (session.scheduleEndTime == null) {
      return Duration.zero;
    }
    final diff = session.scheduleEndTime!.difference(DateTime.now());

    return diff.isNegative ? Duration.zero : diff;
  }

  // 已经过去多少时间
  Duration get elapsed {
    if (session.startTime == null) {
      return Duration.zero;
    }
    if (isPaused) {
      return session.pausedRemaining;
    }
    final duration = DateTime.now().difference(
      session.startTime!,
    );

    return duration > Duration(minutes:AppConstants.maxMinutes)
        ? Duration(minutes: AppConstants.maxMinutes)
        : duration;
  }

  Duration get displayDuration {
    return isCountdown ? remaining : elapsed;
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

  // MARK: session get
  Duration get userSetDuration => session.userSetDuration;
  int get currentCollectibleItemId => session.currentCollectibleItemId;
  int get currentTagId => session.currentTagId;
  bool get isCountdown => session.isCountdown;

  // MARK: State
  FocusState get state => session.state;
  bool get isRunning => state == FocusState.running;
  bool get isPaused => state == FocusState.paused;
  bool get isFinished => state == FocusState.finished;
  bool get isSetting => state == FocusState.setting;
}

extension FocusProviderAction on FocusProvider {

  Future<void> updateMinutes(int minutes) async {
    session = session.copyWith(userSetDuration: Duration(minutes: minutes));
    await saveSession();
    notifyListeners();
  }

  Future<void> changeCountdownMode(bool isCountdown) async {
    session = session.copyWith(isCountdown: isCountdown);
    await saveSession();
    notifyListeners();
  }

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
      scheduleEndTime: isCountdown ? now.add(session.userSetDuration) : null,
      clearCurrentRecordId: true,
    );

    final record = FocusRecord(
      isCountdown: isCountdown,
      startTime: now,
      endTime: isCountdown ? now.add(session.userSetDuration) : now,
      targetSeconds: isCountdown ? session.userSetDuration.inSeconds : 0,
      actualSeconds: 0,
      completed: false,
      collectibleItemId: session.currentCollectibleItemId,
      tagId: session.currentTagId,
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
      pausedRemaining: isCountdown ? remaining : elapsed,
    );

    await saveSession();
    notifyListeners();
  }

  Future<void> resume() async {
    final now = DateTime.now();

    session = session.copyWith(
      state: FocusState.running,
      startTime: isCountdown ? session.startTime : now.subtract(session.pausedRemaining),
      scheduleEndTime: isCountdown ? now.add(session.pausedRemaining) : null,
      pausedRemaining: Duration.zero,
    );

    await saveSession();
    notifyListeners();
  }

  Future<void> cancel() async {
    if (session.recordId != null) {
      final record = await FocusRecordRepository.instance.findById(session.recordId!);

      if (record != null) {
        record.endTime = DateTime.now();
        record.actualSeconds = isCountdown
            ? session.userSetDuration.inSeconds - remaining.inSeconds
            : elapsed.inSeconds;
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
      final record = await FocusRecordRepository.instance.findById(session.recordId!);

      if (record != null) {
        record.endTime = DateTime.now();
        record.actualSeconds = isCountdown
            ? session.userSetDuration.inSeconds
            : elapsed.inSeconds;
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
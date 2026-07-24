import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:forest_focus/core/repository/collectible_repository.dart';
import 'package:forest_focus/core/repository/tag_repository.dart';
import 'package:forest_focus/util/extension.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/repository/focus_record_repository.dart';
import '../../../core/service/notification_service.dart';
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
    await updateState();
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
        print("当前的状态:${session.state}");

        if (!isRunning) {
          return;
        }

        await updateState();

        notifyListeners();
      },
    );
  }

  Future<void> updateState() async {
    if (!isRunning) return;

    await NotificationService.instance.showRunningNotification(
      title: '🌱 正在专注',
      body: displayDuration.mmss,
    );

    if (remaining <= Duration.zero) {
      await enterFinishState();
    }
  }

  // 这个是在轮训中由程序决定的状态变化
  Future<void> enterFinishState() async {
    if (isFinished) {
      return;
    }

    if (session.recordId != null) {
      final record = await FocusRecordRepository.instance.findById(session.recordId!);

      if (record != null) {
        record.endTime = DateTime.now();
        record.actualSeconds = isCountdown
            ? session.userSetDuration.inSeconds
            : Duration(minutes: AppConstants.maxCountUpMinutes).inSeconds;
        await FocusRecordRepository.instance.update(record);
      }
    }

    session = session.copyWith(
      state: FocusState.finished,
      pausePassedDuration: Duration.zero,
      clearStartTime: true,
      clearEndTime: true,
      clearCurrentRecordId: true,
    );

    await saveSession();

    await loadTotalMinute();

    await NotificationService.instance.showRunningNotification(
      title: '恭喜完成了专注',
      body: "",
    );
    await NotificationService.instance.cancelCompletedNotification();

    notifyListeners();
  }

}

extension FocusProviderSession on FocusProvider{

  Future<void> loadTotalMinute() async {
    // final totalSeconds = await FocusRecordRepository.instance.getTotalFocusSeconds();
    // totalMinute = totalSeconds.focusDuration;
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

}

extension FocusProviderGetter on FocusProvider{

  Duration get totalDuration => isCountdown
      ? session.userSetDuration
      : Duration(minutes: AppConstants.maxCountUpMinutes);

  // 倒计时还剩下多少时间
  Duration get remaining {
    if (isPaused) {
      return totalDuration - session.pausePassedDuration;
    }

    if (session.endTime == null) return Duration.zero;

    final diff = session.endTime!.difference(DateTime.now());

    return diff.isNegative ? Duration.zero : diff;
  }

  Duration get passedDuration {
    return totalDuration - remaining;
  }

  Duration get displayDuration {
    if(isSetting){
      return isCountdown ? session.userSetDuration : Duration.zero;
    }else{
      return isCountdown ? remaining : totalDuration - remaining;
    }
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

  Future<void> changeTargetMinutes(int minutes) async {
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

  Future<void> clkStart() async {
    final now = DateTime.now();

    final endTime = isCountdown ?
      now.add(session.userSetDuration) :
      now.add(const Duration(minutes: AppConstants.maxCountUpMinutes));

    session = session.copyWith(
      state: FocusState.running,
      endTime:endTime,
      pausePassedDuration: Duration.zero,
      clearCurrentRecordId: true,
    );

    final record = FocusRecord(
      isCountdown: isCountdown,
      startTime: now,
      endTime: null,
      targetSeconds: isCountdown ? session.userSetDuration.inSeconds : null,
      actualSeconds: 0,
      collectibleItemId: session.currentCollectibleItemId,
      tagId: session.currentTagId,
      createdAt: now,
    );

    final id = await FocusRecordRepository.instance.insert(record);

    session = session.copyWith(recordId: id);

    await saveSession();

    await NotificationService.instance.showRunningNotification(
      title: '🌱 正在专注',
      body: displayDuration.mmss,
    );

    await NotificationService.instance.scheduleCompletedNotification(
      dateTime: endTime,
    );

    notifyListeners();
  }

  Future<void> clkPause() async {
    session = session.copyWith(
      state: FocusState.paused,
      pausePassedDuration: totalDuration - remaining,
      clearEndTime: true
    );

    await saveSession();
    await NotificationService.instance.cancelRunningNotification();
    await NotificationService.instance.cancelCompletedNotification();
    notifyListeners();
  }

  Future<void> clkResume() async {
    final now = DateTime.now();

    // 还剩下多少时间
    final remaining = totalDuration - session.pausePassedDuration;

    final scheduleEndTime = now.add(remaining);

    session = session.copyWith(
      state: FocusState.running,
      endTime: scheduleEndTime,
      pausePassedDuration: Duration.zero,
    );

    await saveSession();
    await NotificationService.instance.showRunningNotification(
      title: '🌱 正在专注',
      body: displayDuration.mmss,
    );
    await NotificationService.instance.scheduleCompletedNotification(
      dateTime: scheduleEndTime,
    );
    notifyListeners();
  }

  // 点击取消
  Future<void> clkCancel() async {
    if (session.recordId != null) {
      final record = await FocusRecordRepository.instance.findById(session.recordId!);

      if (record != null) {
        record.endTime = DateTime.now();
        record.actualSeconds = (totalDuration - remaining).inSeconds;
        await FocusRecordRepository.instance.update(record);
      }
    }

    session = session.copyWith(
      state: FocusState.setting,
      pausePassedDuration: Duration.zero,
      clearStartTime: true,
      clearEndTime: true,
      clearCurrentRecordId: true,
    );

    await saveSession();

    await NotificationService.instance.cancelRunningNotification();
    await NotificationService.instance.cancelCompletedNotification();

    notifyListeners();
  }

}
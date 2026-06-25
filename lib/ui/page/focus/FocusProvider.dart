import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../../model/FocusRecord.dart';
import '../../../repository/FocusRecordRepository.dart';
import '../../../model/FocusState.dart';
import '../../../repository/DBManager.dart';



// 核心玩法，收集系统
// 农作物：小麦，胡萝卜，玉米啥的
// 鸡，鸭，鱼，牛，羊，猪
// 小麦啥的，可以做饲料，鸡吃了饲料可以产鸡蛋，鸡蛋可以做面包，面包可以喂鸭子啥的


class FocusProvider extends ChangeNotifier {

  static const _kState = 'state';
  static const _kStart = 'start';
  static const _kEnd = 'end';
  static const _kUserSetDuration = 'user_set_duration';
  static const _kPausedRemaining = 'paused_remaining';
  static const _kCurrentRecordId = 'current_record_id';

  Duration userSetDuration = Duration(minutes: 10); // 用户一开始设定的时间
  String totalMinute = "";

  FocusState state = FocusState.setting;
  Duration pausedRemaining = Duration.zero; // 暂停后的剩余时间
  DateTime? startTime;
  DateTime? scheduleEndTime; // 预计结束时间，用来记录还剩下多长时间
  int? currentRecordId;// 当前专注的id

  Timer? _ticker;

  FocusProvider() {
    loadFromSharedPreferences();
    startTimer();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> loadFromSharedPreferences() async {
    final prefs = await SharedPreferences.getInstance();

    final stateStr = prefs.getString(_kState); // 获取之前的状态
    final startMs = prefs.getInt(_kStart); // 获取开始时间
    final endMs = prefs.getInt(_kEnd); // 获取结束时间
    final userSetSeconds = prefs.getInt(_kUserSetDuration); // 获取设定时间
    final pausedSeconds = prefs.getInt(_kPausedRemaining); // 暂停恢复时间
    final localCurrentRecordId = prefs.getInt(_kCurrentRecordId);// 当前任务ID

    if (pausedSeconds != null) {
      pausedRemaining = Duration(seconds: pausedSeconds);
    }

    if(localCurrentRecordId != null){
      currentRecordId = localCurrentRecordId;
    }

    if (userSetSeconds != null) {
      userSetDuration = Duration(seconds: userSetSeconds);
    }

    if (stateStr == null) return;
    state = FocusState.values.firstWhere(
          (e) => e.name == stateStr,
      orElse: () => FocusState.setting,
    );

    if (startMs != null) {
      startTime = DateTime.fromMillisecondsSinceEpoch(startMs);
    }

    if (endMs != null) {
      scheduleEndTime = DateTime.fromMillisecondsSinceEpoch(endMs);
    }

    await checkPageState();
    await loadTotalMinute();
    notifyListeners();
  }

  Future<void> loadTotalMinute() async{
    final totalSeconds = await FocusRecordRepository().getTotalFocusSeconds();
    totalMinute = formatTotalFocusTime(totalSeconds);
    notifyListeners();
  }

  Future<void> checkPageState() async{ // 更正页面状态
    if (state == FocusState.running){
      if(scheduleEndTime != null && DateTime.now().isAfter(scheduleEndTime!)){
        await finish();
      }
    }
  }

  void startTimer() {
    _ticker?.cancel();

    _ticker = Timer.periodic(
      const Duration(seconds: 1), (_) {
        if (state == FocusState.running) {
          checkPageState();
          notifyListeners();
        }
      },
    );
  }

  // region method
  // 定时器圆盘更新函数
  Future<void> updateMinutes(int value) async{
    userSetDuration = Duration(minutes: value);
    await saveDataToPrefs();
    notifyListeners();
  }

  Future<void> start() async {
    pausedRemaining = Duration.zero;
    startTime = DateTime.now();
    scheduleEndTime = startTime!.add(userSetDuration);
    state = FocusState.running;
    // 生成一条记录
    final record = FocusRecord(
      startTime: startTime!,
      endTime: scheduleEndTime!,
      targetSeconds: userSetDuration.inSeconds,
      actualSeconds: 0,
      completed: false,
      createdAt: DateTime.now(),
    );
    currentRecordId = await FocusRecordRepository().insert(record);
    await saveDataToPrefs();

    notifyListeners();
  }

  Future<void> cancel() async {
    if (currentRecordId != null) {
      final record = await FocusRecordRepository().findById(currentRecordId!);
      if (record != null) {
        record.endTime = DateTime.now();
        record.actualSeconds = userSetDuration.inSeconds - remaining.inSeconds;
        record.completed = false;
        await FocusRecordRepository().update(record);
      }
    }
    currentRecordId = null;
    pausedRemaining = Duration.zero;
    startTime = null;
    scheduleEndTime = null;
    state = FocusState.setting;
    await saveDataToPrefs();

    notifyListeners();
  }

  Future<void> pause() async {
    pausedRemaining = remaining;
    state = FocusState.paused;
    await saveDataToPrefs();

    notifyListeners();
  }

  Future<void> resume() async {
    scheduleEndTime = DateTime.now().add(pausedRemaining);
    pausedRemaining = Duration.zero;
    state = FocusState.running;
    await saveDataToPrefs();

    notifyListeners();
  }

  // 完成专注
  Future<void> finish() async {
    if (state == FocusState.finished) {
      return;
    }

    if (currentRecordId != null) {
      final record = await FocusRecordRepository().findById(currentRecordId!);
      if (record != null) {
        record.endTime = DateTime.now();
        record.actualSeconds = userSetDuration.inSeconds;
        record.completed = true;
        await FocusRecordRepository().update(record);
      }
    }

    currentRecordId = null;
    state = FocusState.finished;
    startTime = null;
    scheduleEndTime = null;
    pausedRemaining = Duration.zero;
    await saveDataToPrefs();
    await loadTotalMinute();
    notifyListeners();
  }

  // endregion

  // region get

  Duration get remaining {
    if (state == FocusState.paused) {
      return pausedRemaining;
    }
    if (scheduleEndTime == null) return Duration.zero;

    final diff = scheduleEndTime!.difference(DateTime.now());

    return diff.isNegative ? Duration.zero : diff;
  }

  String get plantName {
    final m = userSetDuration.inMinutes;

    if (m < 20) return 'assets/plant_1.png';
    if (m < 40) return 'assets/plant_2.png';
    if (m < 60) return 'assets/plant_3.png';
    return 'assets/plant_4.png';
  }

  String formatTotalFocusTime(int totalSeconds) {
    final duration = Duration(seconds: totalSeconds);
    final hours = duration.inHours;
    final minutes = duration.inMinutes % 60;
    return '${hours}小时${minutes}分钟';
  }

  // endregion

  // region help func

  Future<void> saveDataToPrefs() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_kState, state.name);
    await prefs.setInt(_kUserSetDuration, userSetDuration.inSeconds);
    await prefs.setInt(_kPausedRemaining, pausedRemaining.inSeconds);

    if (startTime != null) {
      await prefs.setInt(_kStart, startTime!.millisecondsSinceEpoch);
    }else {
      await prefs.remove(_kStart);
    }

    if (scheduleEndTime != null) {
      await prefs.setInt(_kEnd, scheduleEndTime!.millisecondsSinceEpoch);
    }else {
      await prefs.remove(_kEnd);
    }

    if (currentRecordId != null) {
      await prefs.setInt(_kCurrentRecordId, currentRecordId!,);
    } else {
      await prefs.remove(_kCurrentRecordId,);
    }
  }

  // endregion

}
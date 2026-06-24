import 'dart:async';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/FocusState.dart';


class FocusProvider extends ChangeNotifier {

  static const _kState = 'state';
  static const _kStart = 'start';
  static const _kEnd = 'end';
  static const _kUserSetDuration = 'user_set_duration';
  static const _kPausedRemaining = 'paused_remaining';

  Duration userSetDuration = Duration(minutes: 10); // 用户一开始设定的时间

  FocusState state = FocusState.setting;
  Duration pausedRemaining = Duration.zero; // 暂停后的剩余时间
  DateTime? startTime;
  DateTime? endTime;

  Timer? _ticker;

  FocusProvider() {
    loadDataFromDB();
    startTimer();
  }

  @override
  void dispose() {
    _ticker?.cancel();
    super.dispose();
  }

  Future<void> loadDataFromDB() async {
    final prefs = await SharedPreferences.getInstance();

    final stateStr = prefs.getString(_kState); // 获取之前的状态
    final startMs = prefs.getInt(_kStart); // 获取开始时间
    final endMs = prefs.getInt(_kEnd); // 获取结束时间
    final userSetSeconds = prefs.getInt(_kUserSetDuration); // 获取设定时间
    final pausedSeconds = prefs.getInt(_kPausedRemaining); // 暂停恢复时间

    if (pausedSeconds != null) {
      pausedRemaining = Duration(seconds: pausedSeconds);
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
      endTime = DateTime.fromMillisecondsSinceEpoch(endMs);
    }

    checkPageState();
    notifyListeners();
  }

  void checkPageState() { // 更正页面状态
    if (state == FocusState.running){
      if(endTime != null && DateTime.now().isAfter(endTime!)){
        state = FocusState.finished;
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
    await saveState();
    notifyListeners();
  }

  Future<void> start() async {
    pausedRemaining = Duration.zero;
    startTime = DateTime.now();
    endTime = startTime!.add(userSetDuration);
    state = FocusState.running;
    await saveState();

    notifyListeners();
  }

  Future<void> cancel() async {
    pausedRemaining = Duration.zero;
    startTime = null;
    endTime = null;
    state = FocusState.setting;
    await saveState();

    notifyListeners();
  }

  Future<void> pause() async {
    pausedRemaining = remaining;
    startTime = null;
    endTime = null;
    state = FocusState.paused;
    await saveState();

    notifyListeners();
  }

  Future<void> resume() async {
    startTime = DateTime.now();
    endTime = startTime!.add(pausedRemaining);
    pausedRemaining = Duration.zero;
    state = FocusState.running;
    await saveState();

    notifyListeners();
  }

  Future<void> restart() async{
    await cancel();
  }

  // endregion

  // region get
  Duration get remaining {
    if (state == FocusState.paused) {
      return pausedRemaining;
    }
    if (endTime == null) return Duration.zero;

    final diff = endTime!.difference(DateTime.now());

    return diff.isNegative ? Duration.zero : diff;
  }

  String get plantName {
    final m = userSetDuration.inMinutes;

    if (m < 20) return 'assets/plant_1.png';
    if (m < 40) return 'assets/plant_2.png';
    if (m < 60) return 'assets/plant_3.png';
    return 'assets/plant_4.png';
  }
  // endregion

  // region help func

  Future<void> saveState() async {
    final prefs = await SharedPreferences.getInstance();

    await prefs.setString(_kState, state.name);
    await prefs.setInt(_kUserSetDuration, userSetDuration.inSeconds);
    await prefs.setInt(_kPausedRemaining, pausedRemaining.inSeconds);

    if (startTime != null) {
      await prefs.setInt(_kStart, startTime!.millisecondsSinceEpoch);
    }else {
      await prefs.remove(_kStart);
    }

    if (endTime != null) {
      await prefs.setInt(_kEnd, endTime!.millisecondsSinceEpoch);
    }else {
      await prefs.remove(_kEnd);
    }
  }

  // endregion

}
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../../model/FocusState.dart';

class FocusSession {
  FocusState state;
  Duration userSetDuration;
  Duration pausedRemaining;

  DateTime? startTime;
  DateTime? scheduleEndTime;

  int? currentRecordId;
  int selectedRewardId;

  FocusSession({
    this.state = FocusState.setting,
    this.userSetDuration = const Duration(minutes: 10),
    this.pausedRemaining = Duration.zero,
    this.startTime,
    this.scheduleEndTime,
    this.currentRecordId,
    this.selectedRewardId = 2,
  });

  @override
  String toString() {
    return 'FocusSession('
        'state: $state, '
        'userSetDuration: $userSetDuration, '
        'pausedRemaining: $pausedRemaining, '
        'startTime: $startTime, '
        'scheduleEndTime: $scheduleEndTime, '
        'currentRecordId: $currentRecordId, '
        'selectedRewardId: $selectedRewardId'
        ')';
  }
}

class FocusSessionRepository {
  FocusSessionRepository._();

  static final FocusSessionRepository instance =
  FocusSessionRepository._();

  static const _kState = 'state';
  static const _kStart = 'start';
  static const _kEnd = 'end';
  static const _kUserSetDuration = 'user_set_duration';
  static const _kPausedRemaining = 'paused_remaining';
  static const _kCurrentRecordId = 'current_record_id';
  static const _kSelectedRewardId = 'selected_reward_id';

  SharedPreferences? _prefs;

  Future<SharedPreferences> get _sp async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  /// 读取 Session
  Future<FocusSession> load() async {
    final sp = await _sp;

    final stateName = sp.getString(_kState);

    return FocusSession(
      state: FocusState.values.firstWhere(
            (e) => e.name == stateName,
        orElse: () => FocusState.setting,
      ),
      userSetDuration: Duration(
        seconds: sp.getInt(_kUserSetDuration) ?? 600,
      ),
      pausedRemaining: Duration(
        seconds: sp.getInt(_kPausedRemaining) ?? 0,
      ),
      startTime: sp.getInt(_kStart) == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
        sp.getInt(_kStart)!,
      ),
      scheduleEndTime: sp.getInt(_kEnd) == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
        sp.getInt(_kEnd)!,
      ),
      currentRecordId: sp.getInt(_kCurrentRecordId),
      selectedRewardId:
      sp.getInt(_kSelectedRewardId) ?? 2,
    );
  }

  /// 保存 Session
  Future<void> save(FocusSession session) async {
    final sp = await _sp;

    await sp.setString(_kState, session.state.name);

    await sp.setInt(
      _kUserSetDuration,
      session.userSetDuration.inSeconds,
    );

    await sp.setInt(
      _kPausedRemaining,
      session.pausedRemaining.inSeconds,
    );

    await sp.setInt(
      _kSelectedRewardId,
      session.selectedRewardId,
    );

    if (session.startTime != null) {
      await sp.setInt(
        _kStart,
        session.startTime!.millisecondsSinceEpoch,
      );
    } else {
      await sp.remove(_kStart);
    }

    if (session.scheduleEndTime != null) {
      await sp.setInt(
        _kEnd,
        session.scheduleEndTime!.millisecondsSinceEpoch,
      );
    } else {
      await sp.remove(_kEnd);
    }

    if (session.currentRecordId != null) {
      await sp.setInt(
        _kCurrentRecordId,
        session.currentRecordId!,
      );
    } else {
      await sp.remove(_kCurrentRecordId);
    }
  }

  /// 清空 Session
  Future<void> clear() async {
    final sp = await _sp;

    await sp.remove(_kState);
    await sp.remove(_kStart);
    await sp.remove(_kEnd);
    await sp.remove(_kUserSetDuration);
    await sp.remove(_kPausedRemaining);
    await sp.remove(_kCurrentRecordId);
    await sp.remove(_kSelectedRewardId);
  }
}
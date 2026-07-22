import 'FocusState.dart';

class FocusSession {
  final FocusState state;
  final Duration userSetDuration;
  final Duration pausedRemaining;
  final DateTime? startTime;
  final DateTime? scheduleEndTime;
  final int? recordId;
  final int currentCollectibleItemId;
  final int currentTagId;
  final bool isCountdown;

  const FocusSession({
    this.state = FocusState.setting,
    this.isCountdown = true,
    required this.userSetDuration,
    this.pausedRemaining = Duration.zero,
    this.startTime,
    this.scheduleEndTime,
    this.recordId,
    required this.currentCollectibleItemId,
    required this.currentTagId,
  });

  FocusSession copyWith({
    FocusState? state,
    bool? isCountdown,
    Duration? userSetDuration,
    Duration? pausedRemaining,
    DateTime? startTime,
    DateTime? scheduleEndTime,
    int? recordId,
    int? currentCollectibleItemId,
    int? currentTagId,
    bool clearStartTime = false,
    bool clearScheduleEndTime = false,
    bool clearCurrentRecordId = false,
  }) {
    return FocusSession(
      state: state ?? this.state,
      isCountdown: isCountdown ?? this.isCountdown,
      userSetDuration: userSetDuration ?? this.userSetDuration,
      pausedRemaining: pausedRemaining ?? this.pausedRemaining,
      startTime: clearStartTime ? null : (startTime ?? this.startTime),
      scheduleEndTime: clearScheduleEndTime ? null : (scheduleEndTime ?? this.scheduleEndTime),
      recordId: clearCurrentRecordId ? null : (recordId ?? this.recordId),
      currentCollectibleItemId: currentCollectibleItemId ?? this.currentCollectibleItemId,
      currentTagId: currentTagId ?? this.currentTagId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state': state.name,
      'isCountdown':isCountdown,
      'userSetDuration': userSetDuration.inSeconds,
      'pausedRemaining': pausedRemaining.inSeconds,
      'startTime': startTime?.millisecondsSinceEpoch,
      'scheduleEndTime': scheduleEndTime?.millisecondsSinceEpoch,
      'recordId': recordId,
      'currentCollectibleItemId': currentCollectibleItemId,
      'currentTagId': currentTagId,
    };
  }

  factory FocusSession.fromJson(Map<String, dynamic> json) {
    return FocusSession(
      state: FocusState.values.firstWhere(
            (e) => e.name == json['state'],
        orElse: () => FocusState.setting,
      ),
      isCountdown: json['isCountdown'] as bool,
      userSetDuration: Duration(
        seconds: json['userSetDuration'] as int,
      ),
      pausedRemaining: Duration(
        seconds: json['pausedRemaining'] as int,
      ),
      startTime: json['startTime'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
        json['startTime'] as int,
      ),
      scheduleEndTime: json['scheduleEndTime'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
        json['scheduleEndTime'] as int,
      ),
      recordId: json['recordId'] as int?,
      currentCollectibleItemId: json['currentCollectibleItemId'] as int,
      currentTagId: json['currentTagId'] as int,
    );
  }

}
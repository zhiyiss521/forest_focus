import 'FocusState.dart';

class FocusSession {
  final FocusState state;
  final Duration userSetDuration;
  final Duration pausedRemaining;
  final DateTime? startTime;
  final DateTime? scheduleEndTime;
  final int? currentRecordId;
  final int currentCollectibleItemId;
  final int currentTagId;

  const FocusSession({
    this.state = FocusState.setting,
    this.userSetDuration = const Duration(minutes: 10),
    this.pausedRemaining = Duration.zero,
    this.startTime,
    this.scheduleEndTime,
    this.currentRecordId,
    required this.currentCollectibleItemId,
    required this.currentTagId,
  });

  FocusSession copyWith({
    FocusState? state,
    Duration? userSetDuration,
    Duration? pausedRemaining,
    DateTime? startTime,
    DateTime? scheduleEndTime,
    int? currentRecordId,
    int? currentCollectibleItemId,
    int? currentTagId,
    bool clearStartTime = false,
    bool clearScheduleEndTime = false,
    bool clearCurrentRecordId = false,
  }) {
    return FocusSession(
      state: state ?? this.state,
      userSetDuration: userSetDuration ?? this.userSetDuration,
      pausedRemaining: pausedRemaining ?? this.pausedRemaining,
      startTime: clearStartTime ? null : (startTime ?? this.startTime),
      scheduleEndTime: clearScheduleEndTime
          ? null
          : (scheduleEndTime ?? this.scheduleEndTime),
      currentRecordId: clearCurrentRecordId
          ? null
          : (currentRecordId ?? this.currentRecordId),
      currentCollectibleItemId: currentCollectibleItemId ?? this.currentCollectibleItemId,
      currentTagId: currentTagId ?? this.currentTagId,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'state': state.name,
      'userSetDuration': userSetDuration.inSeconds,
      'pausedRemaining': pausedRemaining.inSeconds,
      'startTime': startTime?.millisecondsSinceEpoch,
      'scheduleEndTime': scheduleEndTime?.millisecondsSinceEpoch,
      'currentRecordId': currentRecordId,
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
      userSetDuration: Duration(
        seconds: json['userSetDuration'] ?? 600,
      ),
      pausedRemaining: Duration(
        seconds: json['pausedRemaining'] ?? 0,
      ),
      startTime: json['startTime'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
        json['startTime'],
      ),
      scheduleEndTime: json['scheduleEndTime'] == null
          ? null
          : DateTime.fromMillisecondsSinceEpoch(
        json['scheduleEndTime'],
      ),
      currentRecordId: json['currentRecordId'],
      currentCollectibleItemId: json['currentCollectibleItemId'],
      currentTagId: json['currentTagId']
    );
  }

}
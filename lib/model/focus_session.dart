import 'FocusState.dart';

class FocusSession {
  final FocusState state;
  final bool isCountdown;

  final Duration userSetDuration;
  final Duration pausePassedDuration; // 暂停时已经过了多长时间

  final DateTime? endTime;

  final int? recordId;
  final int currentCollectibleItemId;
  final int currentTagId;


  const FocusSession({
    this.state = FocusState.setting,
    this.isCountdown = true,
    required this.userSetDuration,
    this.pausePassedDuration = Duration.zero,
    this.endTime,
    this.recordId,
    required this.currentCollectibleItemId,
    required this.currentTagId,
  });

  FocusSession copyWith({
    FocusState? state,
    bool? isCountdown,
    Duration? userSetDuration,
    Duration? pausePassedDuration,
    DateTime? endTime,
    int? recordId,
    int? currentCollectibleItemId,
    int? currentTagId,
    bool clearStartTime = false,
    bool clearEndTime = false,
    bool clearCurrentRecordId = false,
  }) {
    return FocusSession(
      state: state ?? this.state,
      isCountdown: isCountdown ?? this.isCountdown,
      userSetDuration: userSetDuration ?? this.userSetDuration,
      pausePassedDuration: pausePassedDuration ?? this.pausePassedDuration,
      endTime: clearEndTime ? null : (endTime ?? this.endTime),
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
      'pausePassedDuration': pausePassedDuration.inSeconds,
      'endTime': endTime?.millisecondsSinceEpoch,
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
      userSetDuration: Duration(seconds: json['userSetDuration'] as int,),
      pausePassedDuration: Duration(seconds: json['pausePassedDuration'] as int,),
      endTime: json['endTime'] == null ? null : DateTime.fromMillisecondsSinceEpoch(json['endTime'] as int,),
      recordId: json['recordId'] as int?,
      currentCollectibleItemId: json['currentCollectibleItemId'] as int,
      currentTagId: json['currentTagId'] as int,
    );
  }

}
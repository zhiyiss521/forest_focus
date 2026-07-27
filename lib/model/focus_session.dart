import 'FocusState.dart';

class FocusSession {
  // 运行的状态
  final int? recordId;
  final FocusState state;
  final Duration pausePassedDuration;
  final DateTime? endTime;

  // 需要保存的用户设置
  final Duration userSetDuration;
  final bool isCountdown;
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
    int? recordId,
    int? currentCollectibleItemId,
    int? currentTagId,
    Duration? userSetDuration,
    Duration? pausePassedDuration,
    DateTime? endTime,
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
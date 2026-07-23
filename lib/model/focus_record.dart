import '../core/constants/app_constants.dart';

class FocusRecord {
  int? id;
  final bool isCountdown;
  final DateTime startTime;
  DateTime? endTime; // 实际结束时间，在进行中record，结束时间为null
  final int? targetSeconds;
  int actualSeconds;
  final int collectibleItemId;
  final int tagId;
  final DateTime createdAt;

  FocusRecord({
    this.id,
    this.isCountdown = true,
    required this.startTime,
    this.endTime,
    this.targetSeconds,
    required this.actualSeconds,
    required this.collectibleItemId,
    required this.tagId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'is_countdown' :isCountdown ? 1: 0,
    'start_time': startTime.millisecondsSinceEpoch,
    'end_time': endTime?.millisecondsSinceEpoch,
    'target_seconds': targetSeconds,
    'actual_seconds': actualSeconds,
    'collectible_item_id': collectibleItemId,
    'tag_id': tagId,
    'created_at': createdAt.millisecondsSinceEpoch,
  };

  factory FocusRecord.fromMap(Map<String, dynamic> map) => FocusRecord(
    id: map['id'] as int?,
    isCountdown: (map['is_countdown'] as int) == 1,
    startTime: DateTime.fromMillisecondsSinceEpoch(map['start_time'] as int),
    endTime: map['end_time'] == null ? null : DateTime.fromMillisecondsSinceEpoch(map['end_time'] as int),
    targetSeconds: map['target_seconds'] as int?,
    actualSeconds: map['actual_seconds'] as int,
    collectibleItemId: map['collectible_item_id'] as int,
    tagId: map['tag_id'] as int,
    createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
  );


  bool get completed {
    if (isCountdown) {
      return targetSeconds != null && actualSeconds >= targetSeconds!;
    }
    return actualSeconds >= const Duration(minutes: AppConstants.minMinutes).inSeconds;
  }

}
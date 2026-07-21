class FocusRecord {
  int? id;
  final DateTime startTime;
  DateTime endTime;
  final int targetSeconds;
  int actualSeconds;
  bool completed;
  final int collectibleItemId;
  final int tagId;
  final DateTime createdAt;

  FocusRecord({
    this.id,
    required this.startTime,
    required this.endTime,
    required this.targetSeconds,
    required this.actualSeconds,
    required this.completed,
    required this.collectibleItemId,
    required this.tagId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() => {
    'id': id,
    'start_time': startTime.millisecondsSinceEpoch,
    'end_time': endTime.millisecondsSinceEpoch,
    'target_seconds': targetSeconds,
    'actual_seconds': actualSeconds,
    'completed': completed ? 1 : 0,
    'collectible_item_id': collectibleItemId,
    'tag_id': tagId,
    'created_at': createdAt.millisecondsSinceEpoch,
  };

  factory FocusRecord.fromMap(Map<String, dynamic> map) => FocusRecord(
    id: map['id'] as int?,
    startTime: DateTime.fromMillisecondsSinceEpoch(map['start_time'] as int),
    endTime: DateTime.fromMillisecondsSinceEpoch(map['end_time'] as int),
    targetSeconds: map['target_seconds'] as int,
    actualSeconds: map['actual_seconds'] as int,
    completed: (map['completed'] as int) == 1,
    collectibleItemId: map['collectible_item_id'] as int,
    tagId: map['tag_id'] as int,
    createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at'] as int),
  );
}
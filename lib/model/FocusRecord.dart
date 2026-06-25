class FocusRecord {

  int? id;

  final DateTime startTime;
  DateTime endTime;
  final int targetSeconds;
  int actualSeconds;
  bool completed;
  final String? rewardId;
  final DateTime createdAt;

  FocusRecord({
    this.id,
    required this.startTime,
    required this.endTime,
    required this.targetSeconds,
    required this.actualSeconds,
    required this.completed,
    this.rewardId,
    required this.createdAt,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'start_time': startTime.millisecondsSinceEpoch,
      'end_time': endTime.millisecondsSinceEpoch,
      'target_seconds': targetSeconds,
      'actual_seconds': actualSeconds,
      'completed': completed ? 1 : 0,
      'reward_id': rewardId,
      'created_at': createdAt.millisecondsSinceEpoch,
    };
  }

  factory FocusRecord.fromMap(Map<String, dynamic> map) {
    return FocusRecord(
      id: map['id'],
      startTime: DateTime.fromMillisecondsSinceEpoch(map['start_time']),
      endTime: DateTime.fromMillisecondsSinceEpoch(map['end_time']),
      targetSeconds: map['target_seconds'],
      actualSeconds: map['actual_seconds'],
      completed: map['completed'] == 1,
      rewardId: map['reward_id'],
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['created_at']),
    );
  }
}
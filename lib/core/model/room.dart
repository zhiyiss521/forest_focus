enum RoomStatus {
  waiting,
  playing,
  finished;

  static RoomStatus fromJson(String value) {
    return RoomStatus.values.firstWhere(
          (status) => status.name.toUpperCase() == value,
    );
  }
}

class Room {
  final int roomId;
  final String roomCode;
  final bool isHost;
  final RoomStatus status;

  const Room({
    required this.roomId,
    required this.roomCode,
    required this.isHost,
    required this.status,
  });

  factory Room.fromJson(Map<String, dynamic> json) {
    return Room(
      roomId: json['roomId'],
      roomCode: json['roomCode'],
      isHost: json['host'],
      status: RoomStatus.fromJson(json['status']),
    );
  }
}
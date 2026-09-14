class Friend {
  final int id;
  final String email;
  final String? nickname;
  final String? avatar;
  final bool online;

  Friend({
    required this.id,
    required this.email,
    this.nickname,
    this.avatar,
    this.online = false,
  });

  factory Friend.fromJson(Map<String, dynamic> json) {
    return Friend(
      id: json['id'],
      email: json['email'],
      nickname: json['nickname'],
      avatar: json['avatar'],
      online: json['online'] ?? false,
    );
  }
}
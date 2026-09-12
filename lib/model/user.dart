class User {
  final int id;
  final String email;
  final String? token;
  final String? nickname;
  final String? avatar;
  final String? createdAt;
  final String? updatedAt;

  User({
    required this.id,
    required this.email,
    this.token,
    this.nickname,
    this.avatar,
    this.createdAt,
    this.updatedAt,
  });

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'],
      email: json['email'],
      token: json['token'],
      nickname: json['nickname'],
      avatar: json['avatar'],
      createdAt: json['createdAt'],
      updatedAt: json['updatedAt'],
    );
  }

  User copyWith({
    int? id,
    String? email,
    String? token,
    String? nickname,
    String? avatar,
    String? createdAt,
    String? updatedAt,
  }) {
    return User(
      id: id ?? this.id,
      email: email ?? this.email,
      token: token ?? this.token,
      nickname: nickname ?? this.nickname,
      avatar: avatar ?? this.avatar,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'email': email,
      'token': token,
      'nickname': nickname,
      'avatar': avatar,
      'createdAt': createdAt,
      'updatedAt': updatedAt,
    };
  }

  @override

  String toString() {
    return 'User('
        'id: $id, '
        'email: $email, '
        'token: $token, '
        'nickname: $nickname, '
        'avatar: $avatar, '
        'createdAt: $createdAt, '
        'updatedAt: $updatedAt'
        ')';
  }
}
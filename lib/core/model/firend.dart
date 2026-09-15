import '../constants/app_constants.dart';
import '../util/forest_log.dart';

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

  String? get avatarUrl {
    if (avatar == null || avatar!.isEmpty) {
      return null;
    }

    if (avatar!.startsWith('http://') ||
        avatar!.startsWith('https://')) {
      return avatar;
    }

    final ret = '${AppConstants.kBaseUrl}$avatar';
    FFLog.d("avatarUrl:$ret");
    return ret;
  }
}
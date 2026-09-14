import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:forest_focus/core/model/user.dart';
import 'package:forest_focus/core/util/forest_log.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../service/websocket_service.dart';

class AuthProvider extends ChangeNotifier {
  static const String _userKey = 'user';

  User? _user;
  bool _initialized = false;

  User? get user => _user;

  bool get isLogin => _user != null;

  bool get initialized => _initialized;

  Future<void> init() async {
    if (_initialized) return;

    final prefs = await SharedPreferences.getInstance();
    final json = prefs.getString(_userKey);

    if (json != null) {
      try {
        final data = jsonDecode(json);

        _user = User.fromJson( Map<String, dynamic>.from(data),);
        FFLog.d(_user);
      } catch (_) {
        _user = null;
        await prefs.remove(_userKey);
      }
    }

    _initialized = true;

    if (isLogin) {
      WebSocketService.instance.connect(this);
    }

    notifyListeners();
  }

  Future<void> saveUser(User user) async {
    final prefs = await SharedPreferences.getInstance();

    _user = user;

    await prefs.setString(
      _userKey,
      jsonEncode(user.toJson()),
    );

    WebSocketService.instance.connect(this);

    notifyListeners();
  }

  Future<void> updateUser({
    int? id,
    String? email,
    String? token,
    String? nickname,
    String? avatar,
    String? createdAt,
    String? updatedAt,
  }) async {
    if (_user == null) return;

    final user = _user!.copyWith(
      id: id,
      email: email,
      token: token,
      nickname: nickname,
      avatar: avatar,
      createdAt: createdAt,
      updatedAt: updatedAt,
    );

    await saveUser(user);
  }

  User? getUser() {
    return _user;
  }

  Future<void> logout() async {
    WebSocketService.instance.disconnect();

    final prefs = await SharedPreferences.getInstance();

    _user = null;

    await prefs.remove(_userKey);

    notifyListeners();
  }

}
import 'package:flutter/foundation.dart';
import '../../../common/auth_provider.dart';
import '../../../network/api_service.dart';

class ProfileProvider extends ChangeNotifier {
  final AuthProvider authProvider;

  ProfileProvider(this.authProvider);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String get nickname => authProvider.user?.nickname ?? '';

  String get avatar => authProvider.user?.avatar ?? '';

  Future<void> updateNickname(String nickname) async {
    _isLoading = true;
    notifyListeners();

    try {
      final value = nickname.trim();

      await ApiService.updateProfile(
        nickname: value,
      );

      await authProvider.updateUser(
        nickname: value,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateAvatar(String avatar) async {
    _isLoading = true;
    notifyListeners();

    try {
      await ApiService.updateProfile(
        avatar: avatar,
      );

      await authProvider.updateUser(
        avatar: avatar,
      );
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
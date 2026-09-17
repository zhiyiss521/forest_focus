import 'dart:io';
import 'package:flutter/foundation.dart';
import '../../../core/network/user_api.dart';
import '../../../core/provider/auth_provider.dart';

class ProfileProvider extends ChangeNotifier {
  final AuthProvider authProvider;

  ProfileProvider(this.authProvider);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  String get nickname => authProvider.user?.nickname ?? '';

  String get avatar => authProvider.user?.avatar ?? '';

  File? _avatarFile;

  File? get avatarFile => _avatarFile;

  void setAvatarFile(File file) {
    _avatarFile = file;
    notifyListeners();
  }

  Future<void> uploadAvatar() async {
    if (_avatarFile == null) {
      return;
    }

    _isLoading = true;
    notifyListeners();

    try {
      final avatarUrl = await UserApi.uploadAvatar(_avatarFile!);

      await authProvider.updateUser(
        avatar: avatarUrl,
      );
      _avatarFile = null;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> updateNickname(String nickname) async {
    _isLoading = true;
    notifyListeners();

    try {
      final value = nickname.trim();

      await UserApi.updateProfile(
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
      await UserApi.updateProfile(
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




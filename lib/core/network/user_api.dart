import 'dart:io';

import 'package:dio/dio.dart';

import 'ff_request.dart';

class UserApi {

  static Future<dynamic> login({ required String email, required String password,}) {
    return FFRequest.post(
        '/api/users/login',
        data: {
          'email': email,
          'password': password,
        },
        needLogin: false
    );
  }

  static Future<dynamic> register({ required String email, required String password,}) {
    return FFRequest.post(
        '/api/users',
        data: {
          'email': email,
          'password': password,
        },
        needLogin: false
    );
  }

  static Future<dynamic> updateProfile({ String? nickname, String? avatar,}) {
    return FFRequest.put('/api/users/profile',
      data: {
        if (nickname != null) 'nickname': nickname,
        if (avatar != null) 'avatar': avatar,
      },
    );
  }

  static Future<dynamic> uploadAvatar(File file) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
    });

    return FFRequest.post(
      '/api/users/avatar',
      data: formData,
    );
  }

}
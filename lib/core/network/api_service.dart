import 'dart:io';

import 'package:dio/dio.dart';

import 'ff_request.dart';

class ApiService {

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

  // #################################### friend ########################################################################
  static Future<dynamic> getFriends() {
    return FFRequest.get(
      '/api/friends',
    );
  }

  static Future<dynamic> getFriendRequests() {
    return FFRequest.get(
      '/api/friends/requests',
    );
  }

  static Future<dynamic> sendFriendRequest(String email) {
    return FFRequest.post(
      '/api/friends/requests',
      data: {
        "email":email
      }
    );
  }

  static Future<dynamic> acceptFriendRequest(int requestId) {
    return FFRequest.post(
      '/api/friends/requests/$requestId/accept',
    );
  }



}
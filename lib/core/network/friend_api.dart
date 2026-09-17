import 'ff_request.dart';

class FriendApi {
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
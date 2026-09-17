import 'ff_request.dart';

class RoomApi {

  static Future<dynamic> createRoom() {
    return FFRequest.post(
      '/api/rooms',
    );
  }

}
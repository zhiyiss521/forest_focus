import 'package:flutter/foundation.dart';
import 'package:forest_focus/core/model/firend.dart';
import 'package:forest_focus/core/model/friend_request.dart';
import 'package:forest_focus/core/network/api_service.dart';
import 'package:forest_focus/core/util/forest_log.dart';
import 'package:forest_focus/ui/widget/hud.dart';

import '../service/websocket_service.dart';

class FriendProvider extends ChangeNotifier {

  FriendProvider() {
    WebSocketService.instance.addMessageListener(
      handleWebSocketMessage,
    );
  }

  @override
  void dispose() {
    WebSocketService.instance.removeMessageListener(
      handleWebSocketMessage,
    );
    super.dispose();
  }


  List<Friend> _friends = [];

  List<FriendRequest> _friendRequests = [];

  int get pendingRequestCount => _friendRequests.length;

  List<Friend> get friends => _friends;

  List<FriendRequest> get friendRequests => _friendRequests;

  Future<void> loadFriends() async {
    try{
      final result = await ApiService.getFriends();
      FFLog.d(result);
      _friends = (result as List)
          .map(
            (item) => Friend.fromJson(
          Map<String, dynamic>.from(item),
        ),
      ).toList();
      FFLog.d(_friends);
    }catch (e){

    }

    notifyListeners();
  }

  Future<void> loadFriendRequests() async {
    final result = await ApiService.getFriendRequests();

    try{
      _friendRequests = (result as List)
          .map(
            (item) => FriendRequest.fromJson(
          Map<String, dynamic>.from(item),
        ),
      ).toList();

      notifyListeners();
    }catch (e){

    }

  }

  Future<void> sendFriendRequest(String email) async {
    await ApiService.sendFriendRequest(email);

  }

  Future<void> acceptFriendRequest(int requestId) async {
    await ApiService.acceptFriendRequest(requestId);
  }

  Future<void> rejectFriendRequest(int requestId) async {
    // 后面开发
  }

  void updateOnlineStatus(int userId, bool online,) {
    final index = _friends.indexWhere(
          (friend) => friend.id == userId,
    );

    if (index == -1) return;

    final friend = _friends[index];

    _friends[index] = Friend(
      id: friend.id,
      email: friend.email,
      nickname: friend.nickname,
      avatar: friend.avatar,
      online: online,
    );

    notifyListeners();
  }

  void clear() {
    _friends = [];
    _friendRequests = [];

    notifyListeners();
  }

  int? getFriendIndexByUserId(int userId) {
    var index = _friends.indexWhere( (friend) => friend.id == userId,);
    if(index != -1){
      return index;
    }else{
      return null;
    }
  }

  void handleWebSocketMessage(String type, dynamic data) {
    final userId = data as int;
    switch (type) {
      case 'FRIEND_ONLINE':
        updateOnlineStatus(userId, true);
        var friendIndex = getFriendIndexByUserId(userId);
        if(friendIndex != null){
          var friend = friends[friendIndex];
          FFHUD.showFriendOnline(nickname: friend.nickname ?? friend.email,avatarUrl: friend.avatarUrl);
        }
        break;
      case 'FRIEND_OFFLINE':
        updateOnlineStatus(userId, false);
        break;
    }
  }
}
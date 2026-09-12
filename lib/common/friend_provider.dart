import 'package:flutter/foundation.dart';
import 'package:forest_focus/ui/widget/hud.dart';

import '../../../network/api_service.dart';
import '../model/firend.dart';
import '../model/friend_request.dart';

class FriendProvider extends ChangeNotifier {
  List<Friend> _friends = [];

  List<FriendRequest> _friendRequests = [];

  int get pendingRequestCount => _friendRequests.length;

  List<Friend> get friends => _friends;

  List<FriendRequest> get friendRequests => _friendRequests;

  Future<void> loadFriends() async {
    try{
      final result = await ApiService.getFriends();
      _friends = (result as List)
          .map(
            (item) => Friend.fromJson(
          Map<String, dynamic>.from(item),
        ),
      ).toList();
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
}
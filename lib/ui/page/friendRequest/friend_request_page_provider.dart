import 'dart:ffi';

import 'package:flutter/foundation.dart';

import '../../../common/friend_provider.dart';

class FriendRequestPageProvider extends ChangeNotifier {
  final FriendProvider friendProvider;

  FriendRequestPageProvider(this.friendProvider);

  bool _isLoading = false;

  bool get isLoading => _isLoading;

  Future<void> init() async {
    await getFriendRequest();
  }

  Future<void> getFriendRequest() async { // 获取好友请求信息
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      await friendProvider.loadFriendRequests();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> acceptRequest(int requestId) async { // 接受好友请求
    await friendProvider.acceptFriendRequest(requestId);
    await getFriendRequest();
  }

}
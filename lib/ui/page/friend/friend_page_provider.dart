import 'package:flutter/foundation.dart';
import '../../../core/provider/friend_provider.dart';

class FriendPageProvider extends ChangeNotifier {
  final FriendProvider friendProvider;

  FriendPageProvider(this.friendProvider);

  bool _isLoading = false;
  bool get isLoading => _isLoading;

  Future<void> init() async {
    await loadFriends();
  }

  Future<void> loadFriends() async {
    if (_isLoading) return;

    _isLoading = true;
    notifyListeners();

    try {
      await friendProvider.loadFriends();
      await friendProvider.loadFriendRequests();
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> refresh() async {
    await loadFriends();
  }

}
import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';

class RoomMember {
  const RoomMember({required this.id, required this.name, this.avatarUrl, this.isHost = false});

  final String id;
  final String name;
  final String? avatarUrl;
  final bool isHost;
}

class RoomProvider extends ChangeNotifier {
  RoomProvider({required this.roomId, required this.roomCode, required this.isHost}) {
    _startRoomListener();
  }

  final String roomId;
  final String roomCode;
  final bool isHost;

  bool isLoading = false;
  bool hasError = false;
  String? errorMessage;

  String treeAsset = 'assets/images/tree.png';

  final List<RoomMember> members = [];

  bool get canStart => isHost && members.length >= 2;

  void _startRoomListener() {
    members.clear();
    members.add(const RoomMember(id: 'current_user', name: '我', isHost: true));
    _listenRoomRealtime();
    notifyListeners();
  }

  void _listenRoomRealtime() {
    // TODO: 在这里连接 Firebase / Supabase / WebSocket 等实时房间监听。
    // 收到成员加入、退出、房间开始等事件后，直接更新 Provider 状态。
  }

  Future<void> retry() async {
    hasError = false;
    errorMessage = null;
    isLoading = true;
    notifyListeners();
    try {
      _listenRoomRealtime();
    } catch (e) {
      hasError = true;
      errorMessage = '房间加载失败';
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  Future<void> copyRoomCode() async {
    if (roomCode.isEmpty) return;
    await Clipboard.setData(ClipboardData(text: roomCode));
  }

  Future<void> shareRoom() async {
    // TODO: 接入 share_plus。
    debugPrint('share room: $roomCode');
  }

  Future<void> startPlanting() async {
    if (!canStart) return;
    // TODO: 调用后台接口，将房间状态修改为 started。
    // 成功后根据项目路由进入多人种树页面。
    debugPrint('start planting room: $roomId');
  }

  Future<void> leaveRoom() async {
    // TODO: 调用后台接口退出房间。
    debugPrint('leave room: $roomId');
  }

  void updateMembers(List<RoomMember> value) {
    members
      ..clear()
      ..addAll(value);
    notifyListeners();
  }

  void addMember(RoomMember member) {
    if (members.any((item) => item.id == member.id)) return;
    members.add(member);
    notifyListeners();
  }

  void removeMember(String memberId) {
    members.removeWhere((item) => item.id == memberId);
    notifyListeners();
  }

  void updateTree(String asset) {
    treeAsset = asset;
    notifyListeners();
  }

  @override
  void dispose() {
    _stopRoomListener();
    super.dispose();
  }

  void _stopRoomListener() {
    // TODO: 取消 Firebase / Supabase / WebSocket realtime listener。
  }

  void inviteFriends(){

  }
}
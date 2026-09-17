import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'friend_sheet.dart';
import 'room_provider.dart';

class RoomPage extends StatelessWidget {
  const RoomPage({super.key, required this.roomId, required this.roomCode, required this.isHost});

  final String roomId;
  final String roomCode;
  final bool isHost;

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => RoomProvider(roomId: roomId, roomCode: roomCode, isHost: isHost),
      child: const _RoomView(),
    );
  }
}

class _RoomView extends StatelessWidget {
  const _RoomView();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<RoomProvider>();

    return Scaffold(
      backgroundColor: const Color(0xFFF7F5EE),
      appBar: AppBar(
        title: const Text('一起种'),
        centerTitle: true,
        backgroundColor: const Color(0xFFF7F5EE),
        surfaceTintColor: Colors.transparent,
        elevation: 0,
      ),
      body: _buildBody(context, provider),
    );
  }

  Widget _buildBody(BuildContext context, RoomProvider provider) {
    if (provider.isLoading) return const Center(child: CircularProgressIndicator());
    if (provider.hasError) return _buildError(context, provider);

    return SingleChildScrollView(
      padding: const EdgeInsets.symmetric(horizontal: 24),
      child: Column(
        children: [
          const SizedBox(height: 24),
          _buildTree(provider),
          const SizedBox(height: 20),
          _buildTitle(provider),
          const SizedBox(height: 28),
          _buildRoomCode(context, provider),
          if (provider.isHost) ...[
            const SizedBox(height: 16),
            _buildInviteFriends(context, provider),
          ],
          const SizedBox(height: 28),
          _buildMembers(provider),
          const SizedBox(height: 32),
          _buildBottomButton(provider),
          const SizedBox(height: 20),
        ],
      ),
    );
  }

  Widget _buildTree(RoomProvider provider) {
    return SizedBox(
      height: 180,
      child: Center(
        child: Image.asset(
          provider.treeAsset,
          height: 170,
          fit: BoxFit.contain,
          errorBuilder: (_, __, ___) => const Icon(Icons.park, size: 120, color: Color(0xFF6B8E5A)),
        ),
      ),
    );
  }

  Widget _buildTitle(RoomProvider provider) {
    return Column(
      children: [
        Text(
          provider.isHost ? '房间已创建' : '已加入房间',
          style: const TextStyle(fontSize: 24, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
        ),
        const SizedBox(height: 8),
        Text(
          provider.isHost ? '邀请朋友一起种下这棵树' : '等待房主开始种树',
          style: const TextStyle(fontSize: 14, color: Color(0xFF888888)),
        ),
      ],
    );
  }

  Widget _buildRoomCode(BuildContext context, RoomProvider provider) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(14)),
      child: Row(
        children: [
          const Text('房间密钥', style: TextStyle(fontSize: 14, color: Color(0xFF777777))),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              provider.roomCode,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.w600, letterSpacing: 2, color: Color(0xFF333333)),
            ),
          ),
          InkWell(
            onTap: () async {
              await provider.copyRoomCode();
              if (!context.mounted) return;
              ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('房间密钥已复制')));
            },
            borderRadius: BorderRadius.circular(8),
            child: const Padding(
              padding: EdgeInsets.all(6),
              child: Icon(Icons.copy_outlined, size: 18, color: Color(0xFF777777)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildInviteFriends(BuildContext context, RoomProvider provider) {
    return SizedBox(
      width: double.infinity,
      height: 48,
      child: OutlinedButton.icon(
        onPressed: () => _showFriends(context, provider),
        icon: const Icon(Icons.person_add_alt_1, size: 19),
        label: const Text('邀请好友'),
        style: OutlinedButton.styleFrom(
          foregroundColor: const Color(0xFF6B8E5A),
          side: const BorderSide(color: Color(0xFF6B8E5A)),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
      ),
    );
  }

  void _showFriends(BuildContext context, RoomProvider provider) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => FriendsSheet(roomProvider: provider),
    );
  }

  Widget _buildMembers(RoomProvider provider) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text('房间成员', style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600, color: Color(0xFF333333))),
            const SizedBox(width: 8),
            Text('${provider.members.length}', style: const TextStyle(fontSize: 14, color: Color(0xFF999999))),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(16)),
          child: Column(
            children: [
              for (int i = 0; i < provider.members.length; i++) ...[
                _buildMemberItem(provider.members[i]),
                if (i != provider.members.length - 1) Divider(height: 1, indent: 68, color: Colors.grey.shade200),
              ],
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildMemberItem(RoomMember member) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      child: Row(
        children: [
          CircleAvatar(
            radius: 22,
            backgroundColor: const Color(0xFFE9E8DE),
            backgroundImage: member.avatarUrl != null ? NetworkImage(member.avatarUrl!) : null,
            child: member.avatarUrl == null ? const Icon(Icons.person_outline, color: Color(0xFF777777)) : null,
          ),
          const SizedBox(width: 12),
          Expanded(child: Text(member.name, style: const TextStyle(fontSize: 15, color: Color(0xFF333333)))),
          if (member.isHost)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              decoration: BoxDecoration(color: const Color(0xFFE8F0E4), borderRadius: BorderRadius.circular(6)),
              child: const Text('房主', style: TextStyle(fontSize: 11, color: Color(0xFF6B8E5A))),
            ),
        ],
      ),
    );
  }

  Widget _buildBottomButton(RoomProvider provider) {
    if (!provider.isHost) {
      return Container(
        width: double.infinity,
        height: 52,
        alignment: Alignment.center,
        decoration: BoxDecoration(color: const Color(0xFFEAE9E1), borderRadius: BorderRadius.circular(14)),
        child: const Text('等待房主开始', style: TextStyle(fontSize: 16, color: Color(0xFF888888))),
      );
    }

    return SizedBox(
      width: double.infinity,
      height: 52,
      child: ElevatedButton(
        onPressed: provider.canStart ? provider.startPlanting : null,
        style: ElevatedButton.styleFrom(
          backgroundColor: const Color(0xFF6B8E5A),
          disabledBackgroundColor: const Color(0xFFD9D9D2),
          elevation: 0,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        ),
        child: Text(
          provider.canStart ? '开始种树' : '等待朋友加入',
          style: const TextStyle(fontSize: 16, fontWeight: FontWeight.w500, color: Colors.white),
        ),
      ),
    );
  }

  Widget _buildError(BuildContext context, RoomProvider provider) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(24),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 48, color: Color(0xFF999999)),
            const SizedBox(height: 16),
            Text(provider.errorMessage ?? '房间加载失败', textAlign: TextAlign.center, style: const TextStyle(fontSize: 15, color: Color(0xFF777777))),
            const SizedBox(height: 20),
            TextButton(onPressed: provider.retry, child: const Text('重新加载')),
          ],
        ),
      ),
    );
  }
}
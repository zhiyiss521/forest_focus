import 'package:flutter/material.dart';
import 'package:forest_focus/core/model/firend.dart';

class FriendDetailPage extends StatelessWidget {
  final Friend friend;

  const FriendDetailPage({
    super.key,
    required this.friend,
  });

  @override
  Widget build(BuildContext context) {
    final nickname =
    friend.nickname?.isNotEmpty == true
        ? friend.nickname!
        : '未设置昵称';

    return Scaffold(
      appBar: AppBar(
        title: const Text('好友资料'),
      ),
      body: ListView(
        children: [
          _buildProfileHeader(
            context,
            nickname,
          ),

          const SizedBox(height: 12),

          _buildSection(
            context,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.search,
                ),
                title: const Text('搜索聊天记录'),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  // TODO: 搜索聊天记录
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          _buildSection(
            context,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.notifications_none,
                ),
                title: const Text('消息免打扰'),
                trailing: Switch(
                  value: false,
                  onChanged: (value) {
                    // TODO: 设置消息免打扰
                  },
                ),
              ),

              ListTile(
                leading: const Icon(
                  Icons.delete_sweep_outlined,
                ),
                title: const Text('清空聊天记录'),
                trailing: const Icon(
                  Icons.chevron_right,
                ),
                onTap: () {
                  _clearChatHistory(context);
                },
              ),
            ],
          ),

          const SizedBox(height: 12),

          _buildSection(
            context,
            children: [
              ListTile(
                leading: const Icon(
                  Icons.person_remove_outlined,
                  color: Colors.red,
                ),
                title: const Text(
                  '删除好友',
                  style: TextStyle(
                    color: Colors.red,
                  ),
                ),
                onTap: () {
                  _deleteFriend(context);
                },
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildProfileHeader(
      BuildContext context,
      String nickname,
      ) {
    return Container(
      padding: const EdgeInsets.symmetric(
        vertical: 28,
        horizontal: 20,
      ),
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: [
          CircleAvatar(
            radius: 46,
            backgroundImage:
            friend.avatarUrl != null &&
                friend.avatarUrl!.isNotEmpty
                ? NetworkImage(friend.avatarUrl!)
                : null,
            child:
            friend.avatarUrl == null ||
                friend.avatarUrl!.isEmpty
                ? const Icon(
              Icons.person,
              size: 48,
            )
                : null,
          ),

          const SizedBox(height: 14),

          Text(
            nickname,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.bold,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            'ID: ${friend.id}',
            style: TextStyle(
              fontSize: 14,
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
          ),

          const SizedBox(height: 8),

          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 8,
                height: 8,
                decoration: BoxDecoration(
                  color:
                  friend.online
                      ? Colors.green
                      : Colors.grey,
                  shape: BoxShape.circle,
                ),
              ),
              const SizedBox(width: 6),
              Text(
                friend.online ? '在线' : '离线',
                style: TextStyle(
                  fontSize: 13,
                  color:
                  friend.online
                      ? Colors.green
                      : Colors.grey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSection(
      BuildContext context, {
        required List<Widget> children,
      }) {
    return Container(
      color: Theme.of(context).colorScheme.surface,
      child: Column(
        children: children,
      ),
    );
  }

  void _clearChatHistory(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('清空聊天记录'),
          content: const Text(
            '确定要清空与该好友的聊天记录吗？',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                // TODO: 清空聊天记录
              },
              child: const Text(
                '清空',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }

  void _deleteFriend(BuildContext context) {
    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('删除好友'),
          content: Text(
            '确定要删除好友「${friend.nickname ?? '未设置昵称'}」吗？',
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);

                // TODO: 删除好友
              },
              child: const Text(
                '删除',
                style: TextStyle(
                  color: Colors.red,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}
import 'package:flutter/material.dart';
import 'package:forest_focus/core/model/firend.dart';
import 'package:forest_focus/router/ForestRouter.dart';
import 'package:forest_focus/ui/page/friendRequest/friend_request_page.dart';
import 'package:provider/provider.dart';
import '../../../core/provider/friend_provider.dart';
import '../chat/chat_page.dart';
import 'friend_page_provider.dart';

class FriendPage extends StatelessWidget {
  const FriendPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FriendPageProvider(
        context.read<FriendProvider>(),
      )..init(),
      child: const _FriendPageContent(),
    );
  }
}

class _FriendPageContent extends StatelessWidget {
  const _FriendPageContent();

  @override
  Widget build(BuildContext context) {
    final pageProvider = context.watch<FriendPageProvider>();
    final friendProvider = context.watch<FriendProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('好友列表'),
      ),
      body: RefreshIndicator(
        onRefresh: pageProvider.refresh,
        child: pageProvider.isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : ListView(
          padding: const EdgeInsets.all(16),
          children: [
            _buildFriendRequestTile(
              context,
              friendProvider,
            ),

            const SizedBox(height: 24),

            const Text(
              '我的好友',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
              ),
            ),

            const SizedBox(height: 12),

            if (friendProvider.friends.isEmpty)
              _buildEmpty(context)
            else
              ...friendProvider.friends.map(
                    (friend) => FriendCell(
                  context,
                  friend,
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _buildFriendRequestTile(
      BuildContext context,
      FriendProvider provider,
      ) {
    return Card(
      child: ListTile(
        leading: const CircleAvatar(
          child: Icon(Icons.person_add),
        ),
        title: const Text('新的朋友'),
        trailing: provider.pendingRequestCount > 0
            ? Badge(
          label: Text(
            provider.pendingRequestCount.toString(),
          ),
          child: const Icon(Icons.chevron_right),
        )
            : const Icon(Icons.chevron_right),
        onTap: () {
          ForestRouter.push(const FriendRequestPage());
        },
      ),
    );
  }

  Widget FriendCell( BuildContext context, Friend friend,) {
    final bool isOnline = friend.online;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        vertical: 6,
      ),
      leading: Stack(
        clipBehavior: Clip.none,
        children: [
          CircleAvatar(
            radius: 24,
            backgroundImage:
            friend.avatarUrl != null &&
                friend.avatarUrl!.isNotEmpty
                ? NetworkImage(friend.avatarUrl!)
                : null,
            child: friend.avatarUrl == null ||
                friend.avatarUrl!.isEmpty
                ? const Icon(Icons.person)
                : null,
          ),

          // 在线状态
          Positioned(
            right: -1,
            bottom: -1,
            child: Container(
              width: 14,
              height: 14,
              decoration: BoxDecoration(
                color: isOnline
                    ? Colors.green
                    : Colors.grey,
                shape: BoxShape.circle,
                border: Border.all(
                  color: Theme.of(context)
                      .scaffoldBackgroundColor,
                  width: 2,
                ),
              ),
            ),
          ),
        ],
      ),

      title: Text(
        friend.nickname?.isNotEmpty == true
            ? "${friend.nickname!} id: ${friend.id}"
            : '未设置昵称',
      ),

      subtitle: Row(
        children: [
          Container(
            width: 7,
            height: 7,
            decoration: BoxDecoration(
              color: isOnline
                  ? Colors.green
                  : Colors.grey,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 6),
          Text(
            isOnline ? '在线' : '离线',
            style: TextStyle(
              color: isOnline
                  ? Colors.green
                  : Colors.grey,
            ),
          ),
        ],
      ),

      trailing: const Icon(
        Icons.chevron_right,
      ),

      onTap: () {
        ForestRouter.push(
          ChatPage(friend: friend),
        );
      },
    );
  }

  Widget _buildEmpty(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
        top: 80,
      ),
      child: Column(
        children: [
          Icon(
            Icons.people_outline,
            size: 64,
            color: Theme.of(context)
                .colorScheme
                .outline,
          ),
          const SizedBox(height: 16),
          Text(
            '还没有好友',
            style: TextStyle(
              color: Theme.of(context)
                  .colorScheme
                  .onSurfaceVariant,
            ),
          ),
        ],
      ),
    );
  }
}
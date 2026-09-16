import 'package:flutter/material.dart';
import 'package:forest_focus/core/model/firend.dart';
import 'package:provider/provider.dart';

import '../../../core/model/chat_message.dart';
import '../../../router/ForestRouter.dart';
import '../friendDetail/friend_detail_page.dart';
import 'chat_page_provider.dart';

class ChatPage extends StatelessWidget {
  final Friend friend;

  const ChatPage({
    super.key,
    required this.friend,
  });

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ChatPageProvider(friend),
      child: const _ChatPageContent(),
    );
  }
}

class _ChatPageContent extends StatelessWidget {
  const _ChatPageContent();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<ChatPageProvider>();

    return Scaffold(
      appBar: AppBar(
        titleSpacing: 0,
        title: Row(
          children: [
            CircleAvatar(
              radius: 18,
              backgroundImage: provider.friend.avatarUrl != null && provider.friend.avatarUrl!.isNotEmpty ? NetworkImage(provider.friend.avatarUrl!) : null,
              child: provider.friend.avatarUrl == null || provider.friend.avatarUrl!.isEmpty ? const Icon(Icons.person) : null,
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  provider.friend.nickname?.isNotEmpty == true ? provider.friend.nickname! : '未设置昵称',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: provider.friend.online ? Colors.green : Colors.grey,
                        shape: BoxShape.circle,
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      provider.friend.online ? '在线' : '离线',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                        provider.friend.online ? Colors.green : Colors.grey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.more_vert),
            onPressed: () {
              ForestRouter.push(
                FriendDetailPage(
                  friend: provider.friend,
                ),
              );
            },
          ),
        ],
      ),
      body: GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
        },
        child: Column(
          children: [
            Expanded(
              child: _buildMessageList(context, provider),
            ),

            _buildInputBar(context, provider),
          ],
        ),
      ),
    );
  }

  Widget _buildMessageList(
      BuildContext context,
      ChatPageProvider provider,
      ) {
    if (provider.messages.isEmpty) {
      return const Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.chat_bubble_outline,
              size: 48,
              color: Colors.grey,
            ),
            SizedBox(height: 12),
            Text(
              '开始聊天吧',
              style: TextStyle(
                color: Colors.grey,
                fontSize: 14,
              ),
            ),
          ],
        ),
      );
    }

    return ListView.builder(
      controller: provider.scrollController,
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 16,
      ),
      itemCount: provider.messages.length,
      itemBuilder: (context, index) {
        final message = provider.messages[index];

        return _MessageBubble(
          message: message,
          avatarUrl: provider.friend.avatarUrl,
        );
      },
    );
  }

  Widget _buildInputBar(
      BuildContext context,
      ChatPageProvider provider,
      ) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          8,
          8,
          8,
          8,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surface,
          border: Border(
            top: BorderSide(
              color: Theme.of(context)
                  .colorScheme
                  .outlineVariant,
            ),
          ),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            IconButton(
              onPressed: () {
                _showMoreActions(context);
              },
              icon: const Icon(
                Icons.add_circle_outline,
              ),
            ),

            Expanded(
              child: TextField(
                controller: provider.textController,
                focusNode: provider.focusNode,
                minLines: 1,
                maxLines: 5,
                textInputAction: TextInputAction.newline,
                decoration: InputDecoration(
                  hintText: '输入消息...',
                  filled: true,
                  fillColor:
                  Theme.of(context)
                      .colorScheme
                      .surfaceContainerHighest,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(22),
                    borderSide: BorderSide.none,
                  ),
                  contentPadding:
                  const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 10,
                  ),
                ),
                onSubmitted: (_) {
                  provider.sendMessage();
                },
              ),
            ),

            const SizedBox(width: 6),

            IconButton(
              onPressed: provider.canSend
                  ? provider.sendMessage
                  : null,
              icon: const Icon(
                Icons.send,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showMoreActions(BuildContext context) {
    showModalBottomSheet(
      context: context,
      builder: (_) {
        return SafeArea(
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                _ActionItem(
                  icon: Icons.image_outlined,
                  title: '图片',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 28),
                _ActionItem(
                  icon: Icons.camera_alt_outlined,
                  title: '拍照',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
                const SizedBox(width: 28),
                _ActionItem(
                  icon: Icons.folder_outlined,
                  title: '文件',
                  onTap: () {
                    Navigator.pop(context);
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class _MessageBubble extends StatelessWidget {
  final ChatMessage message;
  final String? avatarUrl;

  const _MessageBubble({
    required this.message,
    required this.avatarUrl,
  });

  @override
  Widget build(BuildContext context) {
    final isMine = message.isMine;

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 14,
      ),
      child: Row(
        mainAxisAlignment:
        isMine
            ? MainAxisAlignment.end
            : MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (!isMine) ...[
            CircleAvatar(
              radius: 20,
              backgroundImage:
              avatarUrl != null &&
                  avatarUrl!.isNotEmpty
                  ? NetworkImage(avatarUrl!)
                  : null,
              child:
              avatarUrl == null ||
                  avatarUrl!.isEmpty
                  ? const Icon(Icons.person)
                  : null,
            ),
            const SizedBox(width: 8),
          ],

          Flexible(
            child: Column(
              crossAxisAlignment:
              isMine
                  ? CrossAxisAlignment.end
                  : CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 14,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color:
                    isMine
                        ? Theme.of(context)
                        .colorScheme
                        .primary
                        : Theme.of(context)
                        .colorScheme
                        .surfaceContainerHighest,
                    borderRadius: BorderRadius.only(
                      topLeft: const Radius.circular(16),
                      topRight: const Radius.circular(16),
                      bottomLeft:
                      Radius.circular(
                        isMine ? 16 : 4,
                      ),
                      bottomRight:
                      Radius.circular(
                        isMine ? 4 : 16,
                      ),
                    ),
                  ),
                  child: Text(
                    message.content,
                    style: TextStyle(
                      fontSize: 15,
                      color:
                      isMine
                          ? Theme.of(context)
                          .colorScheme
                          .onPrimary
                          : Theme.of(context)
                          .colorScheme
                          .onSurface,
                    ),
                  ),
                ),

                const SizedBox(height: 4),

                Text(
                  message.time,
                  style: TextStyle(
                    fontSize: 11,
                    color: Theme.of(context)
                        .colorScheme
                        .outline,
                  ),
                ),
              ],
            ),
          ),

          if (isMine) ...[
            const SizedBox(width: 8),
            const CircleAvatar(
              radius: 20,
              child: Icon(Icons.person),
            ),
          ],
        ],
      ),
    );
  }
}

class _ActionItem extends StatelessWidget {
  final IconData icon;
  final String title;
  final VoidCallback onTap;

  const _ActionItem({
    required this.icon,
    required this.title,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        children: [
          Container(
            width: 54,
            height: 54,
            decoration: BoxDecoration(
              color: Theme.of(context)
                  .colorScheme
                  .surfaceContainerHighest,
              borderRadius: BorderRadius.circular(14),
            ),
            child: Icon(icon),
          ),
          const SizedBox(height: 6),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}


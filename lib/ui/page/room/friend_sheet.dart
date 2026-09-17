import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forest_focus/ui/page/room/room_provider.dart';
import 'package:provider/provider.dart';
import '../../../core/provider/friend_provider.dart';

class FriendsSheet extends StatelessWidget {
  const FriendsSheet({required this.roomProvider});

  final RoomProvider roomProvider;

  @override
  Widget build(BuildContext context) {
    final friendProvider = context.watch<FriendProvider>();
    final friends = friendProvider.friends;

    return Container(
      height: MediaQuery.of(context).size.height * 0.65,
      decoration: const BoxDecoration(
        color: Color(0xFFF7F5EE),
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(20, 16, 12, 12),
            child: Row(
              children: [
                const Expanded(
                  child: Text(
                    '邀请好友',
                    style: TextStyle(fontSize: 20, fontWeight: FontWeight.w600, color: Color(0xFF333333)),
                  ),
                ),
                IconButton(
                  onPressed: () => Navigator.pop(context),
                  icon: const Icon(Icons.close),
                ),
              ],
            ),
          ),
          Expanded(
            child: friends.isEmpty
                ? const Center(
              child: Text(
                '暂无好友',
                style: TextStyle(fontSize: 15, color: Color(0xFF999999)),
              ),
            )
                : ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              itemCount: friends.length,
              itemBuilder: (_, index) {
                final friend = friends[index];

                return Container(
                  margin: const EdgeInsets.only(bottom: 8),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(14),
                  ),
                  child: Row(
                    children: [
                      CircleAvatar(
                        radius: 22,
                        backgroundColor: const Color(0xFFE9E8DE),
                        backgroundImage: friend.avatarUrl != null ? NetworkImage(friend.avatarUrl!) : null,
                        child: friend.avatarUrl == null
                            ? const Icon(Icons.person_outline, color: Color(0xFF777777))
                            : null,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Text(
                          friend.nickname ?? friend.email,
                          style: const TextStyle(fontSize: 15, color: Color(0xFF333333)),
                        ),
                      ),
                      SizedBox(
                        height: 36,
                        child: OutlinedButton(
                          onPressed: () {
                            // 下一步接邀请 API
                          },
                          style: OutlinedButton.styleFrom(
                            foregroundColor: const Color(0xFF6B8E5A),
                            side: const BorderSide(color: Color(0xFF6B8E5A)),
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(9)),
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                          ),
                          child: const Text('邀请'),
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
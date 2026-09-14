import 'package:flutter/material.dart';
import 'package:forest_focus/core/model/friend_request.dart';
import 'package:provider/provider.dart';
import '../../../core/provider/friend_provider.dart';
import '../../widget/ff_input_dialog.dart';
import 'friend_request_page_provider.dart';

class FriendRequestPage extends StatelessWidget {
  const FriendRequestPage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => FriendRequestPageProvider(
        context.read<FriendProvider>(),
      )..init(),
      child: const _FriendRequestPageContent(),
    );
  }
}

class _FriendRequestPageContent extends StatelessWidget {
  const _FriendRequestPageContent();

  @override
  Widget build(BuildContext context) {
    final pageProvider = context.watch<FriendRequestPageProvider>();
    final friendProvider = context.watch<FriendProvider>();

    return Scaffold(
      appBar: AppBar(
        title: const Text('好友'),
        actions: [
          IconButton(
            icon: const Icon(Icons.person_add),
            onPressed: () {
              FFInputDialog.show(
                context,
                title: '添加朋友',
                hintText: '请输入用户邮箱',
                confirmText: '添加',
                cancelText: '取消',
                keyboardType: TextInputType.emailAddress,
                onConfirm: (email) async {
                  await friendProvider.sendFriendRequest(email);
                },
              );
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: pageProvider.getFriendRequest,
        child: pageProvider.isLoading
            ? const Center(
          child: CircularProgressIndicator(),
        )
            : _buildContent(
          context,
          friendProvider,
          pageProvider
        ),
      ),
    );
  }

  Widget _buildContent( BuildContext context, FriendProvider provider,FriendRequestPageProvider pageProvider) {
    if (provider.friendRequests.isEmpty) {
      return ListView(
        physics: const AlwaysScrollableScrollPhysics(),
        children: const [
          SizedBox(height: 200),
          Center(
            child: Text('暂无好友申请'),
          ),
        ],
      );
    }

    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      itemCount: provider.friendRequests.length,
      separatorBuilder: (_, __) {
        return const Divider(
          height: 1,
          indent: 72,
        );
      },
      itemBuilder: (context, index) {
        final request = provider.friendRequests[index];

        return FriendRequestCell(
          request: request,
          onAccept: () async {
            pageProvider.acceptRequest(request.id);
          },
        );
      },
    );
  }
}

class FriendRequestCell extends StatelessWidget {
  final FriendRequest request;
  final Future<void> Function() onAccept;

  const FriendRequestCell({
    required this.request,
    required this.onAccept,
  });

  @override
  Widget build(BuildContext context) {
    final applicant = request.applicant;

    return ListTile(
      contentPadding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      leading: CircleAvatar(
        radius: 24,
        backgroundImage:
        applicant.avatar != null &&
            applicant.avatar!.isNotEmpty
            ? NetworkImage(applicant.avatar!)
            : null,
        child: applicant.avatar == null ||
            applicant.avatar!.isEmpty
            ? const Icon(Icons.person)
            : null,
      ),
      title: Text(
        applicant.nickname?.isNotEmpty == true
            ? applicant.nickname!
            : '未设置昵称',
      ),
      subtitle: const Text('请求添加你为好友'),
      trailing: FilledButton(
        onPressed: onAccept,
        child: const Text('接受'),
      ),
    );
  }
}
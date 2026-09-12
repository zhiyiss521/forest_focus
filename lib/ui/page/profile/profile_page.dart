import 'package:flutter/material.dart';
import 'package:forest_focus/ui/page/profile/profile_provider.dart';
import 'package:provider/provider.dart';

import '../../../common/auth_provider.dart';

class ProfilePage extends StatelessWidget {
  const ProfilePage({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ProfileProvider(
        context.read<AuthProvider>(),
      ),
      child: const _ProfilePageContent(),
    );
  }
}

class _ProfilePageContent extends StatelessWidget {
  const _ProfilePageContent();

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final profileProvider = context.watch<ProfileProvider>();

    final user = authProvider.user;

    if (user == null) {
      return Scaffold(
        appBar: AppBar(
          title: const Text('个人信息'),
        ),
        body: const Center(
          child: Text('未登录'),
        ),
      );
    }

    return Scaffold(
      appBar: AppBar(
        title: const Text('个人信息'),
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const SizedBox(height: 20),

          Center(
            child: GestureDetector(
              onTap: () {
                _showAvatarDialog(context);
              },
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundImage:
                    user.avatar != null && user.avatar!.isNotEmpty
                        ? NetworkImage(user.avatar!)
                        : null,
                    child: user.avatar == null || user.avatar!.isEmpty
                        ? const Icon(
                      Icons.person,
                      size: 52,
                    )
                        : null,
                  ),
                  Positioned(
                    right: 0,
                    bottom: 0,
                    child: Container(
                      width: 32,
                      height: 32,
                      decoration: BoxDecoration(
                        color: Theme.of(context).colorScheme.primary,
                        shape: BoxShape.circle,
                      ),
                      child: const Icon(
                        Icons.camera_alt,
                        size: 18,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),

          const SizedBox(height: 16),

          Center(
            child: Text(
              user.nickname?.isNotEmpty == true
                  ? user.nickname!
                  : '未设置昵称',
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),

          const SizedBox(height: 32),

          Card(
            child: Column(
              children: [
                ListTile(
                  leading: const Icon(Icons.person_outline),
                  title: const Text('昵称'),
                  subtitle: Text(
                    user.nickname?.isNotEmpty == true
                        ? user.nickname!
                        : '未设置',
                  ),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: profileProvider.isLoading
                      ? null
                      : () {
                    _showNicknameDialog(context);
                  },
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('邮箱'),
                  subtitle: Text(user.email),
                ),
              ],
            ),
          ),

          const SizedBox(height: 24),

          SizedBox(
            height: 48,
            child: OutlinedButton(
              onPressed: profileProvider.isLoading
                  ? null
                  : () async {
                await authProvider.logout();

                if (!context.mounted) return;

                Navigator.of(context).pop();
              },
              style: OutlinedButton.styleFrom(
                foregroundColor: Colors.red,
              ),
              child: const Text('退出登录'),
            ),
          ),
        ],
      ),
    );
  }

  void _showNicknameDialog(BuildContext context) {
    final provider = context.read<ProfileProvider>();

    final controller = TextEditingController(
      text: provider.nickname,
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('修改昵称'),
          content: TextField(
            controller: controller,
            autofocus: true,
            maxLength: 20,
            decoration: const InputDecoration(
              hintText: '请输入昵称',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                controller.dispose();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                final nickname = controller.text.trim();

                if (nickname.isEmpty) {
                  return;
                }

                Navigator.pop(dialogContext);
                controller.dispose();

                await provider.updateNickname(nickname);
              },
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
  }

  void _showAvatarDialog(BuildContext context) {
    final provider = context.read<ProfileProvider>();

    final controller = TextEditingController(
      text: provider.avatar,
    );

    showDialog(
      context: context,
      builder: (dialogContext) {
        return AlertDialog(
          title: const Text('修改头像'),
          content: TextField(
            controller: controller,
            decoration: const InputDecoration(
              hintText: '请输入头像 URL',
            ),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.pop(dialogContext);
                controller.dispose();
              },
              child: const Text('取消'),
            ),
            TextButton(
              onPressed: () async {
                final avatar = controller.text.trim();

                if (avatar.isEmpty) {
                  return;
                }

                Navigator.pop(dialogContext);
                controller.dispose();

                await provider.updateAvatar(avatar);
              },
              child: const Text('保存'),
            ),
          ],
        );
      },
    );
  }
}
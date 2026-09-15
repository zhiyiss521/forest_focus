import 'dart:io';

import 'package:flutter/material.dart';
import 'package:forest_focus/ui/page/profile/profile_provider.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import '../../../core/provider/auth_provider.dart';
import '../../widget/ff_input_dialog.dart';

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
              onTap: profileProvider.isLoading ? null : () async {
                final picker = ImagePicker();
                final image = await picker.pickImage(source: ImageSource.gallery,);
                if (image == null) {
                  return;
                }
                profileProvider.setAvatarFile(
                  File(image.path),
                );
                await profileProvider.uploadAvatar();
              },
              child: Stack(
                children: [
                  CircleAvatar(
                    radius: 52,
                    backgroundImage: profileProvider.avatarFile != null ? FileImage(profileProvider.avatarFile!) :
                    user.avatarUrl != null && user.avatarUrl!.isNotEmpty ? NetworkImage(user.avatarUrl!) : null,
                    child: profileProvider.avatarFile == null && (user.avatarUrl == null || user.avatarUrl!.isEmpty) ?
                    const Icon(
                      Icons.person,
                      size: 52,
                    ) : null,
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
                  onTap: profileProvider.isLoading ? null : () {
                    FFInputDialog.show(
                      context,
                      title: '修改昵称',
                      hintText: '请输入昵称',
                      confirmText: '确认',
                      cancelText: '取消',
                      keyboardType: TextInputType.emailAddress,
                      onConfirm: (ret) async {
                        await profileProvider.updateNickname(ret);
                      },
                    );
                  },
                ),

                const Divider(height: 1),

                ListTile(
                  leading: const Icon(Icons.email_outlined),
                  title: const Text('邮箱'),
                  subtitle: Text("${user.email}id:${user.id}"),
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

}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forest_focus/l10n/app_localizations.dart';
import 'package:forest_focus/router/ForestRouter.dart';
import 'package:forest_focus/ui/page/friend/firend_page.dart';
import 'package:forest_focus/ui/page/profile/profile_page.dart';
import 'package:forest_focus/ui/page/tag/tag_manage_page.dart';
import 'package:provider/provider.dart';
import '../../core/provider/auth_provider.dart';
import '../page/set/settings_page.dart';
import '../page/sta/sta_page.dart';
import '../page/timeline/timeline_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();
    final user = authProvider.user;

    return Drawer(
      width: 200,
      child: ListView(
        children: [
          InkWell(
            onTap: () {
              FFRouter.push(const ProfilePage());
            },
            child: Container(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 32,
                    backgroundImage: user?.avatarUrl != null
                        ? NetworkImage(user!.avatarUrl!)
                        : null,
                    child: user?.avatarUrl == null
                        ? const Icon(Icons.person, size: 32)
                        : null,
                  ),
                  const SizedBox(width: 16),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          user?.nickname?.isNotEmpty == true
                              ? user!.nickname!
                              : '未设置',
                          style: const TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Text(
                          '${user?.email} id:${user?.id}',
                          style: const TextStyle(
                            fontSize: 14,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),

          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text(AppLocalizations.of(context)!.statistics),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const StaPage(),
                ),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.park),
            title: Text(AppLocalizations.of(context)!.time_line),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TimelinePage(),
                ),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.park),
            title: Text(
              AppLocalizations.of(context)!.tag,
            ),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const TagManagePage(),
                ),
              );
            },
          ),

          ListTile(
            leading: Icon(Icons.park),
            title: Text("好友"),
            onTap: () {
              FFRouter.pop();
              FFRouter.push(const FriendPage());
            },
          ),

          ListTile(
            leading: Icon(Icons.settings),
            title: Text(AppLocalizations.of(context)!.settings),
            onTap: () {
              Navigator.pop(context);
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => const SettingsPage(),
                ),
              );
            },
          ),
        ],
      ),
    );
  }
}
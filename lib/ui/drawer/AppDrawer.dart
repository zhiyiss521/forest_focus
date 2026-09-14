import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forest_focus/l10n/app_localizations.dart';
import 'package:forest_focus/router/ForestRouter.dart';
import 'package:forest_focus/ui/page/friend/firend_page.dart';
import 'package:forest_focus/ui/page/profile/profile_page.dart';
import 'package:forest_focus/ui/page/tag/tag_manage_page.dart';
import 'package:provider/provider.dart';
import '../../common/auth_provider.dart';
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
          UserAccountsDrawerHeader(
            decoration: const BoxDecoration(),
            currentAccountPicture: CircleAvatar(
              backgroundImage: user?.avatar != null ? NetworkImage(user!.avatar!) : null,
              child: user?.avatar == null ? const Icon(Icons.person, size: 32) : null,
            ),
            accountName: Text(user?.nickname?.isNotEmpty == true ? user!.nickname! : '未设置',
            ),
            accountEmail: Text( "${user?.email} id:${user?.id}"),
            onDetailsPressed: () {
              ForestRouter.push(const ProfilePage());
            },
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
              ForestRouter.pop();
              ForestRouter.push(const FriendPage());
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
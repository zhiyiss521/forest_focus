import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forest_focus/theme/app_colors.dart';
import 'package:forest_focus/ui/page/tag/tag_manage_page.dart';
import '../page/sta/sta_page.dart';
import '../page/timeline/timeline_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200,
      backgroundColor: AppColors.background,
      child: ListView(
        children: [
          ListTile(
            leading: Icon(Icons.bar_chart),
            title: Text('统计'),
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
            title: Text('时间历程'),
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
            title: Text('tag'),
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
            leading: Icon(Icons.settings),
            title: Text('Settings'),
          ),
        ],
      ),
    );
  }
}
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:forest_focus/l10n/app_localizations.dart';
import 'package:forest_focus/ui/page/tag/tag_manage_page.dart';
import '../page/set/settings_page.dart';
import '../page/sta/sta_page.dart';
import '../page/timeline/timeline_page.dart';

class AppDrawer extends StatelessWidget {
  const AppDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200,
      child: ListView(
        children: [
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
              style: TextStyle(
                color: Theme.of(context).colorScheme.onPrimary
              ),
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
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'notification_provider.dart';

class NotificationPage extends StatefulWidget {
  const NotificationPage({super.key});

  @override
  State<NotificationPage> createState() => _NotificationPageState();
}

class _NotificationPageState extends State<NotificationPage> with WidgetsBindingObserver {

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addObserver(this);
    Future.microtask(() {
      context.read<NotificationProvider>().load();
    });
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(
      AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      context.read<NotificationProvider>().refresh();
    }
  }

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<NotificationProvider>();
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Notification",
        ),
      ),
      body: provider.loading ? const Center(
        child: CircularProgressIndicator(),
      ) : ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _buildSectionTitle(
            "System Permission",
          ),
          _buildItem(
            icon: Icons.notifications_outlined,
            title: "Notification",
            value: provider.notificationEnabled ? "Allowed" : "Disabled",
            onTap: () {
              provider.openNotificationSettings();
            },
          ),
          _buildItem(
            icon: Icons.schedule_outlined,
            title: "Exact Alarm",
            value: provider.exactAlarmEnabled ? "Allowed" : "Disabled",
            onTap: () {
              provider.requestExactAlarmPermission();
            },
          ),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {

    return Padding(
      padding: const EdgeInsets.only(
        left: 8,
        bottom: 8,
      ),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleSmall,
      ),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String title,
    required String value,
    required VoidCallback onTap,
  }) {
    return Card(
      child: ListTile(
        leading: Icon(icon),
        title: Text(title),
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              value,
              style: Theme.of(context)
                  .textTheme
                  .bodyMedium,
            ),
            const SizedBox(width: 8),
            const Icon(
              Icons.chevron_right,
            ),
          ],
        ),

        onTap: onTap,
      ),
    );
  }

}
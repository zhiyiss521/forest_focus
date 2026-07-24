import 'package:flutter/material.dart';

import '../../../theme/app_colors.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      appBar: AppBar(
        title: const Text("Settings"),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [

          _buildSectionTitle("Appearance"),
          _buildSection([
            _buildItem(
              icon: Icons.palette_outlined,
              title: "Theme",
              value: "System",
              onTap: () {},
            ),
            _buildItem(
              icon: Icons.language,
              title: "Language",
              value: "English",
              onTap: () {},
            ),
            _buildItem(
              icon: Icons.volume_up_outlined,
              title: "Sound",
              value: "On",
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 24),

          _buildSectionTitle("Notifications"),
          _buildSection([
            _buildItem(
              icon: Icons.notifications_outlined,
              title: "Notification",
              value: "Allowed",
              onTap: () {},
            ),
            _buildItem(
              icon: Icons.schedule_outlined,
              title: "Exact Alarm",
              value: "Allowed",
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 24),

          _buildSectionTitle("Data"),
          _buildSection([
            _buildItem(
              icon: Icons.file_upload_outlined,
              title: "Export Data",
              onTap: () {},
            ),
            _buildItem(
              icon: Icons.file_download_outlined,
              title: "Import Data",
              onTap: () {},
            ),
            _buildItem(
              icon: Icons.restart_alt,
              title: "Reset Statistics",
              onTap: () {},
            ),
          ]),

          const SizedBox(height: 24),

          _buildSectionTitle("About"),
          _buildSection([
            _buildItem(
              icon: Icons.system_update_alt,
              title: "Check for Updates",
              onTap: () {},
            ),
            _buildItem(
              icon: Icons.privacy_tip_outlined,
              title: "Privacy Policy",
              onTap: () {},
            ),
            _buildItem(
              icon: Icons.description_outlined,
              title: "User Agreement",
              onTap: () {},
            ),
            _buildItem(
              icon: Icons.info_outline,
              title: "Version",
              value: "1.0.0",
            ),
          ]),

          const SizedBox(height: 30),
        ],
      ),
    );
  }

  Widget _buildSectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(left: 4, bottom: 10),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: AppColors.textDark,
        ),
      ),
    );
  }

  Widget _buildSection(List<Widget> children) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(children: children),
    );
  }

  Widget _buildItem({
    required IconData icon,
    required String title,
    String? value,
    VoidCallback? onTap,
  }) {
    return InkWell(
      borderRadius: BorderRadius.circular(20),
      onTap: onTap,
      child: Container(
        height: 58,
        padding: const EdgeInsets.symmetric(horizontal: 18),
        child: Row(
          children: [

            Icon(
              icon,
              size: 22,
              color: AppColors.textDark,
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.textDark,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            if (value != null)
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                  color: AppColors.textLight,
                ),
              ),

            if (onTap != null) ...[
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right,
                size: 20,
                color: AppColors.textLight,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
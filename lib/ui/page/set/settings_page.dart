import 'package:flutter/material.dart';
import 'package:forest_focus/l10n/app_localizations.dart';
import 'package:forest_focus/theme/ff_theme_provider.dart';
import 'package:provider/provider.dart';
import '../../../theme/ff_theme.dart';
import '../../widget/ff_picker_sheet.dart';
import 'local_provider.dart';
import 'notification/nofification_page.dart';

class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final themeProvider = context.watch<FFThemeProvider>();
    final localProvider = context.watch<LocaleProvider>();

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
        centerTitle: true,
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          _buildSectionTitle(AppLocalizations.of(context)!.appearance),
          _buildSection([
            _buildItem(
              icon: Icons.palette_outlined,
              title: AppLocalizations.of(context)!.theme,
              value: themeProvider.current!.name,
              onTap: () {
                FFPickerSheet.show<FFTheme>(
                  context,
                  title:AppLocalizations.of(context)!.theme,
                  items: themeProvider.themes,
                  itemLabel: (theme) {
                    return theme.name;
                  },
                  isSelected: (theme) {
                    return themeProvider.current?.id == theme.id;
                  },
                  onSelected: (theme) {
                    themeProvider.changeTheme(theme);
                  },
                );
              },
            ),
            _buildItem(
              icon: Icons.language,
              title: AppLocalizations.of(context)!.language,
              value: localProvider.currentLocalName,
              onTap: () {
                FFPickerSheet.show<Locale>(
                  context,
                  title: AppLocalizations.of(context)!.language,
                  items: LocaleProvider.locales,
                  itemLabel:(local){
                    return LocaleProvider.localeName(local);
                  },
                  isSelected: (locale) {
                    return localProvider.locale.languageCode == locale.languageCode;
                  },
                  onSelected: (locale) {
                    localProvider.changeLocale(locale);
                  },
                );
              },
            ),
            _buildItem(
              icon: Icons.volume_up_outlined,
              title: AppLocalizations.of(context)!.sound,
              value: "On",
              onTap: () {},
            ),
          ],context),

          const SizedBox(height: 24),

          _buildSectionTitle(AppLocalizations.of(context)!.notification),
          _buildSection([
            _buildItem(
              icon: Icons.notifications_outlined,
              title: AppLocalizations.of(context)!.notification,
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => const NotificationPage(),
                  ),
                );
              },
            ),
          ],context),

          const SizedBox(height: 24),

          _buildSectionTitle(AppLocalizations.of(context)!.about),
          _buildSection([
            _buildItem(
              icon: Icons.info_outline,
              title: AppLocalizations.of(context)!.version,
              value: "1.0.0",
            ),
          ],context),
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
        ),
      ),
    );
  }

  Widget _buildSection(List<Widget> children,BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(20),
        color: Theme.of(context).cardColor
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
            ),

            const SizedBox(width: 14),

            Expanded(
              child: Text(
                title,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),

            if (value != null)
              Text(
                value,
                style: const TextStyle(
                  fontSize: 14,
                ),
              ),

            if (onTap != null) ...[
              const SizedBox(width: 6),
              const Icon(
                Icons.chevron_right,
                size: 20,
              ),
            ],
          ],
        ),
      ),
    );
  }
}
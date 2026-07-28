import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../theme/ff_theme_provider.dart';

class ThemePickerSheet extends StatelessWidget {
  const ThemePickerSheet({super.key});

  static Future<void> show(BuildContext context) {
    return showModalBottomSheet(
      context: context,
      builder: (_) => const ThemePickerSheet(),
    );
  }

  @override
  Widget build(BuildContext context) {

    final provider = context.watch<FFThemeProvider>();

    return SafeArea(
      child: ListView.builder(
        shrinkWrap: true,
        itemCount: provider.themes.length,
        itemBuilder: (_, index) {

          final theme = provider.themes[index];

          return ListTile(
            title: Text(theme.name),
            trailing: provider.current?.id == theme.id ? const Icon(Icons.check) : null,
            onTap: () {
              provider.changeTheme(theme);
              Navigator.pop(context);
            },
          );
        },
      ),
    );
  }
}
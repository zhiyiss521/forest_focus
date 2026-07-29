import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:forest_focus/theme/ff_theme_provider.dart';
import 'package:forest_focus/ui/page/focus/FocusPage.dart';
import 'package:forest_focus/ui/page/focus/focus_Provider.dart';
import 'package:forest_focus/ui/page/reward_picker/collectible_provider.dart';
import 'package:forest_focus/ui/page/set/local_provider.dart';
import 'package:forest_focus/ui/page/set/notification/notification_provider.dart';
import 'package:forest_focus/ui/page/tag/tag_provider.dart';
import 'package:provider/provider.dart';
import 'core/repository/DBManager.dart';
import 'core/service/notification_service.dart';
import 'l10n/app_localizations.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );

  await NotificationService.instance.init();
  await DBManager.instance.init();
  final collectible = CollectibleProvider();
  await collectible.load();
  final tag = TagProvider();
  await tag.load();
  final focus = FocusProvider();
  await focus.load();
  final notification = NotificationProvider();
  await notification.load();
  final theme = FFThemeProvider();
  await theme.load();
  final local = LocaleProvider();
  await local.load();

  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider.value(value: theme),
        ChangeNotifierProvider.value(value: collectible),
        ChangeNotifierProvider.value(value: tag),
        ChangeNotifierProvider.value(value: focus),
        ChangeNotifierProvider.value(value: notification),
        ChangeNotifierProvider.value(value: local)
      ],
      child: App()
    ),
  );
}


class App extends StatelessWidget {
  const App({super.key});

  @override
  Widget build(BuildContext context) {

    final colors = context.watch<FFThemeProvider>().current!.colors;
    final localProvider = context.watch<LocaleProvider>();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      builder: FlutterSmartDialog.init(),
      locale: localProvider.locale,
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: LocaleProvider.locales,
      home: const FocusPage(),
      theme: ThemeData(
        scaffoldBackgroundColor: colors.backgroundColor,
        cardColor: colors.cardColor,
        colorScheme: ColorScheme.light(
          primary: colors.primaryColor,
          secondary: colors.secondaryColor,
          error: colors.dangerColor,
          surface: colors.surfaceColor,
          onPrimary: colors.onPrimaryColor
        ),
        textTheme: ThemeData.light().textTheme.apply(
          bodyColor: colors.textColor,
          displayColor: colors.textColor, // 大标题颜色，
        ),
        appBarTheme: AppBarTheme(
          backgroundColor: colors.backgroundColor,
          foregroundColor: colors.textColor,
          elevation: 0, // 阴影？
          centerTitle: true,
        ),
        inputDecorationTheme: InputDecorationTheme(
          hintStyle: TextStyle(
            color: colors.textSecondaryColor,
          ),
        ),
      ),
    );
  }
}
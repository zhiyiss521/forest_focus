import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:forest_focus/ui/page/focus/FocusPage.dart';
import 'package:forest_focus/ui/page/focus/focus_Provider.dart';
import 'package:forest_focus/ui/page/reward_picker/collectible_provider.dart';
import 'package:forest_focus/ui/page/tag/tag_provider.dart';
import 'package:provider/provider.dart';
import 'core/repository/DBManager.dart';

Future<void> main() async{
  WidgetsFlutterBinding.ensureInitialized();

  SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.edgeToEdge,
  );

  SystemChrome.setSystemUIOverlayStyle(
    const SystemUiOverlayStyle(
      statusBarColor: Colors.transparent,
      // systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      systemNavigationBarIconBrightness: Brightness.light,
    ),
  );
  // await NotificationManager.instance.init();


  await DBManager.instance.init();
  final collectibleProvider = CollectibleProvider();
  await collectibleProvider.load();
  final tagProvider = TagProvider();
  await tagProvider.load();

  final focusProvider = FocusProvider();
  await focusProvider.load();

  runApp(
      MultiProvider(
        providers: [
          ChangeNotifierProvider(
            create: (_) => collectibleProvider,
          ),
          ChangeNotifierProvider(
            create: (_) => tagProvider,
          ),
          ChangeNotifierProvider(
            create: (_) => focusProvider,
          ),
        ],
        child: MaterialApp(
          builder: FlutterSmartDialog.init(),
          debugShowCheckedModeBanner: false,
          title: 'Flutter Demo',
          home: const FocusPage(),
        ),
      )
  );
}

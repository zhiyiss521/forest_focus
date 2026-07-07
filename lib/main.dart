import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:forest_focus/ui/page/focus/FocusPage.dart';
import 'package:forest_focus/theme/app_colors.dart';
import 'package:forest_focus/ui/page/reward_picker/collectible_provider.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import 'core/notification_manager.dart';

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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (_) => CollectibleProvider()..load(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'Flutter Demo',
        theme: ThemeData(
          scaffoldBackgroundColor: AppColors.background,
          appBarTheme: const AppBarTheme(
            backgroundColor:AppColors.background,
            foregroundColor: AppColors.tree,
            centerTitle: true,
            elevation: 0,
          ),
          elevatedButtonTheme: ElevatedButtonThemeData(
            style: ElevatedButton.styleFrom(
              backgroundColor:
              AppColors.leaf,
      
              foregroundColor:
              Colors.white,
      
              shape:
              RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(18),
              ),
            ),
          ),
          outlinedButtonTheme: OutlinedButtonThemeData(
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.tree,
      
              side: BorderSide(
                color: AppColors.woodBorder,
                width: 2,
              ),
      
              shape: RoundedRectangleBorder(
                borderRadius:
                BorderRadius.circular(18),
              ),
            ),
          ),
          cardTheme: CardThemeData(
            color: AppColors.paper,
            shape: RoundedRectangleBorder(
              borderRadius:
              BorderRadius.circular(24),
              side: BorderSide(
                color: AppColors.woodBorder,
                width: 2,
              ),
            ),
          ),
          textButtonTheme: TextButtonThemeData(
            style: TextButton.styleFrom(
              foregroundColor:
              AppColors.tree,
            ),
          ),
          textTheme: GoogleFonts.nunitoTextTheme().apply(
            bodyColor: AppColors.tree,
            displayColor: AppColors.tree,
          ),
        ),
        home: const FocusPage(),
      ),
    );
  }
}
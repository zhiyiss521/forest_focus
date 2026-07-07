// import 'package:flutter_local_notifications/flutter_local_notifications.dart';
//
// class NotificationManager {
//
//   NotificationManager._();
//
//   static final instance =
//   NotificationManager._();
//
//   final FlutterLocalNotificationsPlugin
//   plugin =
//   FlutterLocalNotificationsPlugin();
//
//   Future<void> init() async {
//
//     const android =
//     AndroidInitializationSettings(
//       '@mipmap/ic_launcher',
//     );
//
//     const settings =
//     InitializationSettings(
//       android: android,
//       iOS: DarwinInitializationSettings(),
//     );
//
//     await plugin.initialize(settings);
//   }
// }
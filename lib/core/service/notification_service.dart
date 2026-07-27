import 'package:app_settings/app_settings.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:timezone/data/latest.dart' as tz;
import 'package:timezone/timezone.dart' as tz;

class NotificationService {
  NotificationService._();

  static final NotificationService instance = NotificationService._();

  final FlutterLocalNotificationsPlugin plugin = FlutterLocalNotificationsPlugin();


  static const String kFocusRunningChannelId = 'focus_timer_channel';
  static const String kFocusRunningChannelName = '专注中通知';
  static const String kFocusRunningChannelDescription = '专注进行中的通知';
  static const int kFocusRunningNotificationId = 1000;

  static const String kFocusCompletedChannelId = 'focus_completed_channel';
  static const String kFocusCompletedChannelName = '专注完成通知';
  static const String kFocusCompletedChannelDescription = '专注完成提醒';
  static const int kFocusCompletedNotificationId = 1001;

  Future<void> init() async {
    tz.initializeTimeZones();

    const settings = InitializationSettings(
      android: AndroidInitializationSettings(
        '@mipmap/ic_launcher',
      ),
      iOS: DarwinInitializationSettings(),
    );

    await plugin.initialize(settings);

    await initAndroid();
    await initIOS();
  }

  Future<void> initAndroid() async {
    final android = plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) return;

    await android.requestNotificationsPermission();
    await android.requestExactAlarmsPermission();

    const channel = AndroidNotificationChannel(
      kFocusRunningChannelId,
      kFocusRunningChannelName,
      description: kFocusRunningChannelDescription,
      importance: Importance.low,
    );
    await android.createNotificationChannel(channel);

    const completedChannel = AndroidNotificationChannel(
      kFocusCompletedChannelId,
      kFocusCompletedChannelName,
      description: kFocusCompletedChannelDescription,
      importance: Importance.high,
    );
    await android.createNotificationChannel(completedChannel);
  }

  Future<void> initIOS() async {
    final ios = plugin
        .resolvePlatformSpecificImplementation<
        IOSFlutterLocalNotificationsPlugin>();

    if (ios == null) return;

    await ios.requestPermissions(
      alert: true,
      badge: true,
      sound: true,
    );
  }

  Future<void> showRunningNotification({
    required String title,
    required String body,
  }) async {
    const androidDetails = AndroidNotificationDetails(
      kFocusRunningChannelId,
      kFocusRunningChannelName,
      channelDescription: kFocusRunningChannelDescription,
      importance: Importance.low,
      priority: Priority.low,
      ongoing: true,
      autoCancel: false,
    );

    const details = NotificationDetails(
      android: androidDetails,
    );

    await plugin.show(
      kFocusRunningNotificationId,
      title,
      body,
      details,
    );
  }

  Future<void> cancelRunningNotification() async {
    await plugin.cancel(kFocusRunningNotificationId);
  }

  // 专注完成通知
  Future<void> scheduleCompletedNotification({required DateTime dateTime,}) async {
    final android = plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    final canExact = await android?.canScheduleExactNotifications() ?? false;
    final mode = canExact ? AndroidScheduleMode.exactAllowWhileIdle : AndroidScheduleMode.inexactAllowWhileIdle;

    const androidDetails = AndroidNotificationDetails(
      kFocusCompletedChannelId,
      kFocusCompletedChannelName,
      channelDescription: kFocusCompletedChannelDescription,
      importance: Importance.high,
      priority: Priority.high,
    );

    const details = NotificationDetails(
      android: androidDetails,
    );

    try {
      await plugin.zonedSchedule(
        kFocusCompletedNotificationId,
        '🎉 专注完成',
        '你的专注已经结束!',
        tz.TZDateTime.from(dateTime, tz.local),
        details,
        androidScheduleMode: mode,
        payload: 'focus_completed',
      );
    }catch(e){
      debugPrint('schedule notification failed: $e');
    }

  }

  Future<void> cancelCompletedNotification() async {
    await plugin.cancel(kFocusCompletedNotificationId);
  }

}

extension Auth on NotificationService{

  Future<bool> isNotificationEnabled() async {
    final android = plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) {
      return true;
    }
    return await android.areNotificationsEnabled() ?? false;
  }

  Future<bool> isExactAlarmEnabled() async {
    final android = plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (android == null) {
      return true;
    }
    return await android.canScheduleExactNotifications() ?? false;
  }

  // 精确闹钟权限
  Future<void> requestExactAlarmPermission() async {
    final android = plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    await android?.requestExactAlarmsPermission();
  }

  Future<void> requestNotificationPermission() async {

    final android = plugin.resolvePlatformSpecificImplementation<AndroidFlutterLocalNotificationsPlugin>();
    if (android != null) {
      await android.requestNotificationsPermission();
    }

    final ios = plugin.resolvePlatformSpecificImplementation<IOSFlutterLocalNotificationsPlugin>();
    if (ios != null) {
      await ios.requestPermissions(
        alert: true,
        badge: true,
        sound: true,
      );
    }

  }

  Future<void> openNotificationSettings() async {
    await AppSettings.openAppSettings(
      type: AppSettingsType.notification,
    );
  }

}
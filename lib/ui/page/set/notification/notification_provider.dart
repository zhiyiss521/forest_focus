import 'package:flutter/material.dart';

import '../../../../core/service/notification_service.dart';


class NotificationProvider extends ChangeNotifier {

  final NotificationService _service = NotificationService.instance;

  bool _notificationEnabled = false;
  bool get notificationEnabled => _notificationEnabled;

  bool _exactAlarmEnabled = false;
  bool get exactAlarmEnabled => _exactAlarmEnabled;

  bool _loading = false;
  bool get loading => _loading;

  Future<void> load() async {
    _loading = true;
    notifyListeners();
    await _loadNotificationStatus();
    await _loadExactAlarmStatus();
    _loading = false;
    notifyListeners();
  }

  Future<void> _loadNotificationStatus() async {
    _notificationEnabled = await _service.isNotificationEnabled();
  }

  Future<void> _loadExactAlarmStatus() async {
    _exactAlarmEnabled = await _service.isExactAlarmEnabled();
  }

  /// 用户开启通知权限
  Future<void> requestNotificationPermission() async {
    await _service.requestNotificationPermission();
    await refresh();
  }

  Future<void> openNotificationSettings() async {
    await _service.openNotificationSettings();
  }

  Future<void> requestExactAlarmPermission() async {
    await _service.requestExactAlarmPermission();
  }

  Future<void> refresh() async {
    await load();
  }

}
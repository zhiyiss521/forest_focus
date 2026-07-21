import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class HUD {
  HUD._();

  /// Toast
  static void showToast(String message) {
    SmartDialog.showToast(message);
  }

  /// 成功
  static void showSuccess([String message = "操作成功"]) {
    SmartDialog.showToast(message);
  }

  /// 错误
  static void showError([String message = "操作失败"]) {
    SmartDialog.showToast(message);
  }

  /// 信息
  static void showInfo(String message) {
    SmartDialog.showToast(message);
  }

  /// Loading
  static void showLoading({
    String message = "加载中...",
    bool clickMaskDismiss = false,
  }) {
    SmartDialog.showLoading(
      msg: message,
      clickMaskDismiss: clickMaskDismiss,
    );
  }

  /// 隐藏 Loading
  static void dismiss() {
    SmartDialog.dismiss();
  }

  /// 是否正在显示 Loading
  static bool get isLoading => SmartDialog.config.isExist;
}
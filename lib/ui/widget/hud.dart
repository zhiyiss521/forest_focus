import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';

class FFHUD {
  FFHUD._();

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

  static void showFriendOnline({
    required String nickname,
    String? avatarUrl,
  }) {
    SmartDialog.show(
      alignment: Alignment.topCenter,
      maskColor: Colors.transparent,
      clickMaskDismiss: true,
      builder: (_) {
        return Align(
          alignment: Alignment.topCenter,
          child: Material(
            color: Colors.transparent,
            child: Container(
              margin: const EdgeInsets.only(
                top: 60,
                left: 16,
                right: 16,
              ),
              padding: const EdgeInsets.all(12),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.12),
                    blurRadius: 12,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  CircleAvatar(
                    radius: 24,
                    backgroundImage: avatarUrl != null
                        ? NetworkImage(avatarUrl)
                        : null,
                    child: avatarUrl == null
                        ? const Icon(Icons.person)
                        : null,
                  ),

                  const SizedBox(width: 12),

                  Flexible(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          nickname,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        const Text(
                          '上线了，快去和他打个招呼吧',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.grey,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 8),

                  const Icon(
                    Icons.circle,
                    size: 10,
                    color: Colors.green,
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}
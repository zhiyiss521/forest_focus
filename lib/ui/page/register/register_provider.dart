import 'package:flutter/material.dart';
import '../../../core/network/user_api.dart';
import '../../../router/ForestRouter.dart';
import '../../widget/hud.dart';

class RegisterProvider extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  bool isLoading = false;

  Future<void> register() async {
    final email = emailController.text.trim();
    final password = passwordController.text;
    final confirmPassword = confirmPasswordController.text;

    if (email.isEmpty) {
      FFHUD.showError('请输入邮箱');
      return;
    }

    if (password.isEmpty) {
      FFHUD.showError('请输入密码');
      return;
    }

    if (password.length < 6) {
      FFHUD.showError('密码至少6位');
      return;
    }

    if (confirmPassword.isEmpty) {
      FFHUD.showError('请再次输入密码');
      return;
    }

    if (password != confirmPassword) {
      FFHUD.showError('两次密码不一致');
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      await UserApi.register(
        email: email,
        password: password,
      );
      FFHUD.showSuccess('注册成功');
      FFRouter.back();
    } catch (e) {
      if (e is Map<String, dynamic>) {
        FFHUD.showError(e['message']?.toString() ?? '注册失败');
      } else {
        FFHUD.showError('注册失败');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    confirmPasswordController.dispose();
    super.dispose();
  }
}
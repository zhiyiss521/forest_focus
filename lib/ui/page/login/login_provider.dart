import 'package:flutter/material.dart';
import 'package:forest_focus/ui/page/focus/FocusPage.dart';
import 'package:forest_focus/ui/page/register/register_page.dart';
import 'package:provider/provider.dart';
import '../../../common/auth_provider.dart';
import '../../../model/user.dart';
import '../../../network/api_service.dart';
import '../../../router/ForestRouter.dart';
import '../../widget/hud.dart';

class LoginProvider extends ChangeNotifier {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();

  bool isLoading = false;
  bool obscurePassword = true;

  void togglePassword() {
    obscurePassword = !obscurePassword;
    notifyListeners();
  }

  Future<void> login(BuildContext context) async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty) {
      FFHUD.showError('请输入邮箱');
      return;
    }

    if (password.isEmpty) {
      FFHUD.showError('请输入密码');
      return;
    }

    if (password.length < 6) {
      FFHUD.showError('密码不能少于 6 位');
      return;
    }

    isLoading = true;
    notifyListeners();

    try {
      final result = await ApiService.login(
        email: email,
        password: password,
      );

      final user = User.fromJson(result);
      final authProvider = context.read<AuthProvider>();
      await authProvider.saveUser(user);
      FFHUD.showSuccess('登录成功');
      ForestRouter.push(const FocusPage());
    } catch (e) {
      if (e is Map<String, dynamic>) {
        FFHUD.showError(e['message']?.toString() ?? '登录失败');
      } else {
        FFHUD.showError('登录失败');
      }
    } finally {
      isLoading = false;
      notifyListeners();
    }
  }

  void register() {
    ForestRouter.push(RegisterPage());
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}
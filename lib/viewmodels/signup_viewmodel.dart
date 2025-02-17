import 'package:flutter/material.dart';
import '../services/user_service.dart';

class SignUpViewModel extends ChangeNotifier {
  final UserService _userService = UserService();

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isButtonActive = false;
  bool get isButtonActive => _isButtonActive;

  void validateFields() {
    _isButtonActive = emailController.text.isNotEmpty &&
        passwordController.text.isNotEmpty;
    notifyListeners();
  }

  Future<bool> signUp() async {
    try {
      return await _userService.signUp(emailController.text, passwordController.text);
    } catch (e) {
      print("Ошибка регистрации: $e");
      return false;
    }
  }
}

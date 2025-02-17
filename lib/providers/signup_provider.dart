import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class SignUpProvider extends ChangeNotifier {
  static const String _baseUrl = "https://xplora.robosoft.kz/api";
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  bool _isButtonActive = false;
  bool _isLoading = false;
  String? _errorMessage;

  bool get isButtonActive => _isButtonActive;

  bool get isLoading => _isLoading;

  String? get errorMessage => _errorMessage;

  // Валидация полей
  void validateFields() {
    _isButtonActive =
        emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    notifyListeners();
  }

  // Метод для отправки запроса регистрации
  Future<bool> signUp() async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("$_baseUrl/users/signup/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": emailController.text,
          "password": passwordController.text,
        }),
      );

      if (response.statusCode == 200) {
        _isLoading = false;
        notifyListeners();
        return true; // Регистрация успешна
      } else {
        final Map<String, dynamic> responseData = jsonDecode(response.body);
        _errorMessage = responseData["error"] ??
            "Registration error: ${responseData['message']}";
      }
    } catch (e) {
      _errorMessage = "Network error. Try again. ${e}";
    }

    _isLoading = false;
    notifyListeners();
    return false; // Ошибка регистрации
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

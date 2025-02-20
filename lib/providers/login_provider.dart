import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

import 'package:discoveria/services/auth_service.dart';

class LoginProvider extends ChangeNotifier {
  String? _token;
  bool _isLoading = false;
  String? _errorMessage;

  String? get token => _token;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  /// **Авторизация пользователя**
  Future<bool> loginUser(String email, String password) async {
    _isLoading = true;
    _errorMessage = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse("https://xplora.robosoft.kz/api/users/token/"),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "email": email,
          "password": password,
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        print("Response: ${response.body}");

        if (data.containsKey('access') && data['access'] != null) {
          _token = data['access'];

          // Сохранение токена в SharedPreferences
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('token', _token!);

          _isLoading = false;
          notifyListeners();
          AuthService.saveToken(_token!);
          return true;
        } else {
          _errorMessage = "Invalid response from server";
        }
      } else {
        final errorData = jsonDecode(response.body);
        _errorMessage = errorData['detail'] ?? "Invalid credentials";
      }
    } catch (error) {
      _errorMessage = "Error logging in: $error";
    }

    _isLoading = false;
    notifyListeners();
    return false;
  }

  /// **Проверка сохраненного токена**
  Future<void> checkLoginStatus() async {
    _token = await AuthService.getToken();
    notifyListeners();
  }

  /// **Выход из системы**
  Future<void> logout() async {
    await AuthService.logout();
    _token = null;
    notifyListeners();
  }
}

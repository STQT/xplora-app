import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:discoveria/constants/constants.dart';

class AuthService {
  static const String _apiUrl = "https://xplora.robosoft.kz/api";

  // Метод для проверки авторизации
  static Future<bool> isAuthenticated() async {
    final token = await getToken();
    print("TOKEN:    ${token}");
    if (token == null) return false;

    final response = await http.get(
      Uri.parse("$_apiUrl/users/me/"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );
    print(response.statusCode);
    return response.statusCode == 200;
  }

  // Получение токена из SharedPreferences
  static Future<String?> getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString(AuthConst.tokenKey);
  }

  // Сохранение токена
  static Future<void> saveToken(String token) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(AuthConst.tokenKey, token);
  }

  // Удаление токена (выход из системы)
  static Future<void> logout() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(AuthConst.tokenKey);
  }
}

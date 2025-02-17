import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:discoveria/services/auth_service.dart';

class UserService {
  static const String _baseUrl = "https://xplora.robosoft.kz/api/";

  // Получение данных пользователя
  static Future<Map<String, dynamic>?> getUserProfile() async {
    final token = await AuthService.getToken();
    if (token == null) return null;

    final response = await http.get(
      Uri.parse("${_baseUrl}users/me/"),
      headers: {
        'Authorization': 'Bearer $token',
      },
    );

    if (response.statusCode == 200) {
      return jsonDecode(response.body);
    } else {
      return null;
    }
  }

  Future<bool> signUp(String email, String password) async {
    final url = Uri.parse("${_baseUrl}users/signup/");

    final response = await http.post(
      url,
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );

    if (response.statusCode == 201) {
      return true; // Успешная регистрация
    } else {
      throw Exception("Ошибка регистрации: ${response.body}");
    }
  }
}

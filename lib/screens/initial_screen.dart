import 'package:flutter/material.dart';
import 'package:discoveria/services/auth_service.dart';
import 'package:discoveria/services/user_service.dart';

class InitialRouteScreen extends StatefulWidget {
  @override
  _InitialRouteScreenState createState() => _InitialRouteScreenState();
}

class _InitialRouteScreenState extends State<InitialRouteScreen> {
  @override
  void initState() {
    super.initState();
    _determineInitialRoute();
  }

  Future<void> _determineInitialRoute() async {
    try {
      bool isAuth = await AuthService.isAuthenticated();
      print(isAuth);
      print("IS AUTH");

      if (!isAuth) {
        Navigator.pushReplacementNamed(context, '/'); // Перенаправление на WelcomeScreen
        return;
      }

      final userProfile = await UserService.getUserProfile();

      if (userProfile == null || userProfile['profile'] == null) {
        Navigator.pushReplacementNamed(context, '/step1'); // Перенаправление на заполнение анкеты
        return;
      }

      Navigator.pushReplacementNamed(context, '/match'); // Перенаправление на MatchScreen
    } catch (e) {
      Navigator.pushReplacementNamed(context, '/'); // В случае ошибки - WelcomeScreen
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: CircularProgressIndicator()), // Экран загрузки перед редиректом
    );
  }
}

import 'package:flutter/material.dart';
import 'screens/welcome_screen.dart';
import 'screens/login_screen.dart';
import 'screens/complete_profile_step1.dart';
import 'screens/complete_profile_step2.dart';
import 'screens/complete_profile_step3.dart';
import 'screens/match_screen.dart';

void main() {
  runApp(DiscoveriaApp());
}

class DiscoveriaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/',
      routes: {
        '/': (context) => WelcomeScreen(),
        '/login': (context) => LoginScreen(),
        '/step1': (context) => CompleteProfileStep1(),
        '/step2': (context) => CompleteProfileStep2(),
        '/step3': (context) => CompleteProfileStep3(),
        '/match': (context) => MatchScreen(),

      },
    );
  }
}

import 'package:discoveria/providers/email_verification_provider.dart';
import 'package:discoveria/providers/login_provider.dart';
import 'package:discoveria/providers/profile_provider.dart';
import 'package:discoveria/screens/authorization/email_verification_screen.dart';
import 'package:discoveria/screens/authorization/signup_screen.dart';
import 'package:discoveria/screens/welcome_screen.dart';
import 'package:flutter/material.dart';
import 'screens/login_screen.dart';
import 'screens/initial_screen.dart';
import 'screens/complete_profile_step1.dart';
import 'screens/complete_profile_step2.dart';
import 'screens/complete_profile_step3.dart';
import 'screens/match_screen.dart';

import 'package:provider/provider.dart';
import 'package:discoveria/providers/signup_provider.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoginProvider()),
        ChangeNotifierProvider(create: (_) => SignUpProvider()),
        ChangeNotifierProvider(create: (_) => EmailVerificationProvider()),
        ChangeNotifierProvider(create: (_) => ProfileProvider()),
      ],
      child: DiscoveriaApp(),
    ),
  );
}

class DiscoveriaApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      initialRoute: '/initial', // Перенесли FutureBuilder сюда
      routes: {
        '/initial': (context) => InitialRouteScreen(),
        '/': (context) => WelcomeScreen(),
        '/signup': (context) => SignUpScreen(),
        '/verify-email': (context) => EmailVerificationScreen(email: ""),
        '/login': (context) => LoginScreen(),
        '/step1': (context) => CompleteProfileStep1(),
        '/step2': (context) => CompleteProfileStep2(),
        '/step3': (context) => CompleteProfileStep3(),
        '/match': (context) => MatchScreen(),
      },
    );
  }
}

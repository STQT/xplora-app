import 'package:flutter/material.dart';

class AppColors {
  static const Color primaryDark = Color(0xFF00373D);
  static const Color primaryLight = Color(0xFF092D33);
}

class AppTextStyles {
  static const TextStyle logoText = TextStyle(
    color: Colors.white,
    fontSize: 16,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle title = TextStyle(
    color: Colors.white,
    fontSize: 32,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle subtitle = TextStyle(
    color: Colors.white70,
    fontSize: 14,
  );

  static const TextStyle linkText = TextStyle(
    color: Colors.white70,
    fontSize: 14,
    decoration: TextDecoration.underline,
  );
}

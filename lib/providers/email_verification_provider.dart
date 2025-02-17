import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class EmailVerificationProvider with ChangeNotifier {
  final String baseUrl = "https://xplora.robosoft.kz/api";
  bool isLoading = false;
  bool isCodeValid = false;
  int resendCooldown = 60;
  Timer? _timer;

  void updateCodeValid(bool value) {
    isCodeValid = value;
    notifyListeners();
  }

  Future<void> verifyEmail(String email, String code, BuildContext context) async {
    isLoading = true;
    notifyListeners();

    final response = await http.post(
      Uri.parse('$baseUrl/users/verify-email/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "code": code}),
    );

    isLoading = false;
    notifyListeners();

    if (response.statusCode == 200) {
      Navigator.pushNamed(context, '/step1');
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Invalid verification code. Try again.")),
      );
    }
  }

  void startResendTimer() {
    _timer?.cancel();
    resendCooldown = 60;
    notifyListeners();

    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (resendCooldown > 0) {
        resendCooldown--;
        notifyListeners();
      } else {
        timer.cancel();
      }
    });
  }

  Future<void> resendCode(String email, BuildContext context) async {
    if (resendCooldown > 0) return;

    final response = await http.post(
      Uri.parse('$baseUrl/users/resend-verification-code/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email}),
    );

    if (response.statusCode == 200) {
      startResendTimer();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to resend code. Try again.")),
      );
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    super.dispose();
  }
}

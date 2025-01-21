import 'package:flutter/material.dart';
import '../widgets/social_button.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          gradient: LinearGradient(
            colors: [Colors.white, Color(0xFFD0ECEC)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text(
                "Discoveria",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 40),
              Text(
                "Travel together,\nDiscover together",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 32,
                  fontWeight: FontWeight.bold,
                  color: Colors.black87,
                ),
              ),
              SizedBox(height: 16),
              Text(
                "Connect with travelers and create\nunforgettable journeys together!",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: Colors.black54,
                ),
              ),
              SizedBox(height: 40),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SocialButton(
                    icon: Icons.facebook,
                    onTap: () {
                      // Add Facebook login logic
                    },
                  ),
                  SizedBox(width: 16),
                  SocialButton(
                    icon: Icons.g_mobiledata, // Replace with Google icon
                    onTap: () {
                      // Add Google login logic
                    },
                  ),
                  SizedBox(width: 16),
                  SocialButton(
                    icon: Icons.apple,
                    onTap: () {
                      // Add Apple login logic
                    },
                  ),
                ],
              ),
              SizedBox(height: 40),
              ElevatedButton(
                onPressed: () {
                  Navigator.pushNamed(context, '/login');
                },
                child: Text("Go to Login"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

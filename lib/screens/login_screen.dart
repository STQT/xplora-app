import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  bool isButtonActive = false;

  @override
  void initState() {
    super.initState();
    emailController.addListener(_validateFields);
    passwordController.addListener(_validateFields);
  }

  void _validateFields() {
    setState(() {
      isButtonActive =
          emailController.text.isNotEmpty && passwordController.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Navigator.pop(context);
          },
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(24.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Stack(
                children: [
                  Positioned(
                    top: 12,
                    left: 0,
                    child: Container(
                      width: 56,
                      height: 8,
                      color: Color(0xFF58C4B6), // Highlight color
                    ),
                  ),
                  Text(
                    "Log in to Xplora",
                    style: TextStyle(
                      fontFamily: 'Fira Sans Condensed',
                      fontStyle: FontStyle.normal,
                      fontWeight: FontWeight.w400,
                      fontSize: 18,
                      height: 1,
                      color: Color(0xFF121414),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 16),
              Text(
                "Welcome back! Sign in with your social media account or email.",
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontFamily: 'Fira Sans Extra Condensed',
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.w400,
                  fontSize: 16,
                  height: 20 / 16,
                  letterSpacing: 0.1,
                  color: Colors.grey,
                ),
              ),
              SizedBox(height: 24),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  IconButton(
                    icon: Image.asset(
                      'assets/icons/facebook.png',
                      width: 40,
                      height: 40,
                    ),
                    onPressed: () {
                      // Add Facebook login logic
                    },
                  ),
                  SizedBox(width: 16),
                  IconButton(
                    icon: Image.asset(
                      'assets/icons/google.png',
                      width: 40,
                      height: 40,
                    ),
                    onPressed: () {
                      // Add Google login logic
                    },
                  ),
                  SizedBox(width: 16),
                  IconButton(
                    icon: Image.asset(
                      'assets/icons/apple.png',
                      width: 40,
                      height: 40,
                    ),
                    onPressed: () {
                      // Add Apple login logic
                    },
                  ),
                ],
              ),
              SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 8.0),
                    child: Text(
                      "OR",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  Expanded(
                    child: Divider(
                      color: Colors.grey,
                      thickness: 1,
                    ),
                  ),
                ],
              ),
              SizedBox(height: 24),
              TextField(
                controller: emailController,
                decoration: InputDecoration(
                  labelText: "Email",
                  labelStyle: TextStyle(
                    fontFamily: 'Fira Sans Condensed',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 14 / 16,
                    letterSpacing: 0.1,
                    color: Color(0xFF24786D),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFE0E0E0),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF54A59B),
                      width: 2.0,
                    ),
                  ),
                ),
              ),
              SizedBox(height: 16),
              TextField(
                controller: passwordController,
                decoration: InputDecoration(
                  labelText: "Password",
                  labelStyle: TextStyle(
                    fontFamily: 'Fira Sans Condensed',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 14 / 16,
                    letterSpacing: 0.1,
                    color: Color(0xFF24786D),
                  ),
                  enabledBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFFE0E0E0),
                    ),
                  ),
                  focusedBorder: UnderlineInputBorder(
                    borderSide: BorderSide(
                      color: Color(0xFF54A59B),
                      width: 2.0,
                    ),
                  ),
                ),
                obscureText: true,
              ),
              SizedBox(height: 24),
              ElevatedButton(
                onPressed: isButtonActive
                    ? () {
                  Navigator.pushNamed(context, '/step1');
                }
                    : null,
                style: ButtonStyle(
                  backgroundColor: MaterialStateProperty.resolveWith((states) {
                    if (states.contains(MaterialState.disabled)) {
                      return Colors.transparent;
                    }
                    return Color(0xFF20A090);
                  }),
                  shape: MaterialStateProperty.all(
                    RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16.0),
                    ),
                  ),
                  fixedSize: MaterialStateProperty.all(Size(327, 48)),
                  elevation: MaterialStateProperty.all(0),
                ),
                child: Text(
                  "Log in",
                  style: TextStyle(
                    fontFamily: 'Fira Sans Condensed',
                    fontWeight: FontWeight.w400,
                    fontSize: 16,
                    height: 1.0,
                    color: isButtonActive ? Color(0xFFFFFFFF) : Color(0xFF797C7B),
                  ),
                ),
              ),
              TextButton(
                onPressed: () {
                  // Forgot password logic
                },
                child: Text(
                  "Forgot password?",
                  style: TextStyle(
                    fontFamily: 'Fira Sans Condensed',
                    fontStyle: FontStyle.normal,
                    fontWeight: FontWeight.w400,
                    fontSize: 14,
                    height: 1.0,
                    letterSpacing: 0.1,
                    color: Color(0xFF24786D),
                  ),
                ),
                style: ButtonStyle(
                  alignment: Alignment.center,
                  padding: MaterialStateProperty.all(EdgeInsets.zero),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

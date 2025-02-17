import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:discoveria/providers/signup_provider.dart';
import 'email_verification_screen.dart';

class SignUpScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Consumer<SignUpProvider>(
      builder: (context, provider, child) {
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              backgroundColor: Colors.transparent,
              elevation: 0,
              leading: IconButton(
                icon: Icon(Icons.arrow_back, color: Colors.black),
                onPressed: () => Navigator.pop(context),
              ),
            ),
            body: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
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
                          color: Color(0xFF8AC0C7),
                        ),
                      ),
                      Text(
                        "Sign up to Xplora",
                        style: TextStyle(
                          fontFamily: 'Fira Sans Condensed',
                          fontWeight: FontWeight.w400,
                          fontSize: 18,
                          color: Color(0xFF121414),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: 8),
                  Center(
                    child: Text(
                      "We are happy to welcome you!",
                      style: TextStyle(
                        fontFamily: 'Fira Sans Condensed',
                        fontSize: 14,
                        color: Colors.grey,
                      ),
                    ),
                  ),
                  SizedBox(height: 24),

                  // Поле "Email"
                  TextField(
                    controller: provider.emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                      labelStyle: TextStyle(
                        fontFamily: 'Fira Sans Condensed',
                        fontSize: 16,
                        color: Color(0xFF8AC0C7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF8AC0C7), width: 2.0),
                      ),
                    ),
                    onChanged: (_) => provider.validateFields(),
                  ),
                  SizedBox(height: 16),

                  // Поле "Password"
                  TextField(
                    controller: provider.passwordController,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "Password",
                      labelStyle: TextStyle(
                        fontFamily: 'Fira Sans Condensed',
                        fontSize: 16,
                        color: Color(0xFF8AC0C7),
                      ),
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFFE0E0E0)),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Color(0xFF8AC0C7), width: 2.0),
                      ),
                    ),
                    onChanged: (_) => provider.validateFields(),
                  ),
                  Spacer(),

                  // Ошибка
                  if (provider.errorMessage != null)
                    Padding(
                      padding: const EdgeInsets.only(bottom: 12.0),
                      child: Text(
                        provider.errorMessage!,
                        style: TextStyle(color: Colors.red, fontSize: 14),
                      ),
                    ),

                  // Кнопка "Sign Up"
                  Center(
                    child: ElevatedButton(
                      onPressed: provider.isButtonActive
                          ? () async {
                        bool success = await provider.signUp();
                        if (success) {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => EmailVerificationScreen(
                                email: provider.emailController.text,
                              ),
                            ),
                          );
                        }
                      }
                          : null,
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.resolveWith((states) {
                          return provider.isButtonActive
                              ? Color(0xFF8AC0C7)
                              : Color(0xFFF0F0F0);
                        }),
                        shape: MaterialStateProperty.all(
                          RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16.0),
                          ),
                        ),
                        fixedSize: MaterialStateProperty.all(Size(327, 48)),
                        elevation: MaterialStateProperty.all(0),
                      ),
                      child: provider.isLoading
                          ? CircularProgressIndicator(color: Colors.white)
                          : Text(
                        "Sign Up",
                        style: TextStyle(
                          fontFamily: 'Fira Sans Condensed',
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          color: provider.isButtonActive ? Colors.white : Color(0xFF797C7B),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 40),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

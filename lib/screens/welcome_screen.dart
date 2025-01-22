import 'package:flutter/material.dart';

class WelcomeScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Эллипс на заднем плане
          Positioned(
            top: 0,
            left: -150,
            child: Image.asset(
              'assets/images/ellipse_background.png',
              width: 700, // Задайте нужную ширину
              fit: BoxFit.cover,
            ),
          ),
          // Основное содержимое
          Center(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 24.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // Иконка слева
                      Image.asset(
                        'assets/icons/logo_icon.png', // Замените на путь к вашей иконке
                        width: 24, // Задайте ширину иконки
                        height: 24, // Задайте высоту иконки
                      ),
                      // Текст "Discoveria"
                      Text(
                        "Discoveria",
                        style: TextStyle(
                          fontFamily: 'Fira Sans Condensed',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontSize: 16,
                          height: 14 / 16,
                          textBaseline: TextBaseline.alphabetic,
                          color: Color(0xFF121414),
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                  SizedBox(height: 40),
                  Padding(
                    padding: const EdgeInsets.only(left: 100.0), // Добавлен отступ слева
                    child: Align(
                      alignment: Alignment.centerLeft, // Выравнивание по левому краю
                      child: RichText(
                        text: TextSpan(
                          style: TextStyle(
                            fontFamily: 'Abyssinica SIL',
                            fontSize: 68,
                            height: 78 / 68,
                          ),
                          children: [
                            TextSpan(
                              text: "Travel ",
                              style: TextStyle(color: Color(0xFF41B2A4)),
                            ),
                            TextSpan(
                              text: "together,\n",
                              style: TextStyle(color: Color(0xFF121414)),
                            ),
                            TextSpan(
                              text: "Discover ",
                              style: TextStyle(color: Color(0xFF41B2A4)),
                            ),
                            TextSpan(
                              text: "together",
                              style: TextStyle(color: Color(0xFF121414)),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 16),
                  Text(
                    "Connect with travelers and create\nunforgettable journeys together!",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontFamily: 'Fira Sans Condensed',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Color(0xFF797C7B),
                    ),
                  ),
                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      IconButton(
                        icon: Image.asset(
                          'assets/icons/facebook.png',
                          width: 40, // Ширина иконки
                          height: 40, // Высота иконки
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
                  SizedBox(height: 20),
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
                  SizedBox(height: 20),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      // "Existing account?" обычный текст
                      Text(
                        "Existing account?",
                        style: TextStyle(
                          fontFamily: 'Fira Sans Condensed',
                          fontStyle: FontStyle.normal,
                          fontWeight: FontWeight.w400,
                          fontSize: 14,
                          height: 14 / 14,
                          letterSpacing: 0.1,
                          color: Color(0xFF797C7B),
                        ),
                      ),
                      SizedBox(width: 4), // Пробел между текстами
                      // "Log in" кликабельный
                      GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(context, '/login');
                        },
                        child: Text(
                          "Log in",
                          style: TextStyle(
                            fontFamily: 'Fira Sans Condensed',
                            fontStyle: FontStyle.normal,
                            fontWeight: FontWeight.w400,
                            fontSize: 14,
                            height: 14 / 14,
                            letterSpacing: 0.1,
                            color: Color(0xFF202020),
                          ),
                        ),
                      ),
                    ],
                  ),

                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}

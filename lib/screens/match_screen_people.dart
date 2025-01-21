import 'package:flutter/material.dart';

class MatchScreenPeople extends StatefulWidget {
  @override
  _MatchScreenPeopleState createState() => _MatchScreenPeopleState();
}

class _MatchScreenPeopleState extends State<MatchScreenPeople> {
  final List<Map<String, String>> people = [
    {
      "name": "Jihan",
      "age": "20",
      "location": "London 29/10-31/10",
      "image": "https://via.placeholder.com/300.png?text=Jihan"
    },
    {
      "name": "Anel",
      "age": "21",
      "location": "New York 12/12-15/12",
      "image": "https://via.placeholder.com/300.png?text=Anel"
    },
    {
      "name": "Sofia",
      "age": "22",
      "location": "Paris 01/11-05/11",
      "image": "https://via.placeholder.com/300.png?text=Sofia"
    },
    {
      "name": "Liam",
      "age": "24",
      "location": "Tokyo 10/12-15/12",
      "image": "https://via.placeholder.com/300.png?text=Liam"
    },
    {
      "name": "Emma",
      "age": "23",
      "location": "Berlin 20/12-25/12",
      "image": "https://via.placeholder.com/300.png?text=Emma"
    },
  ];

  int currentIndex = 0;
  double xOffset = 0;
  double yOffset = 0;
  double rotation = 0;
  double swipeThreshold = 100;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Отображение карточек профилей
          ...people.asMap().entries.map((entry) {
            int index = entry.key;
            Map<String, String> person = entry.value;

            if (index < currentIndex) return Container(); // Скрыть уже просмотренные карточки

            return Positioned.fill(
              child: buildCard(person, isFront: index == currentIndex),
            );
          }).toList(),
          // Нижняя навигация
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavigationBar(
              currentIndex: 1, // Активная вкладка Match
              onTap: (index) {
                if (index == 0) {
                  Navigator.pushNamed(context, '/message'); // Переход на экран Message
                } else if (index == 2) {
                  Navigator.pushNamed(context, '/profile'); // Переход на экран Profile
                }
              },
              items: [
                BottomNavigationBarItem(
                  icon: Icon(Icons.message),
                  label: "Message",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.group),
                  label: "Match",
                ),
                BottomNavigationBarItem(
                  icon: Icon(Icons.person),
                  label: "Profile",
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget buildCard(Map<String, String> person, {bool isFront = false}) {
    return GestureDetector(
      onPanUpdate: (details) {
        if (!isFront) return;

        setState(() {
          xOffset += details.delta.dx;
          yOffset += details.delta.dy;
          rotation = xOffset / 200; // Ротация пропорциональна смещению
        });
      },
      onPanEnd: (details) {
        if (!isFront) return;

        if (xOffset > swipeThreshold) {
          // Свайп вправо
          handleSwipe(true);
        } else if (xOffset < -swipeThreshold) {
          // Свайп влево
          handleSwipe(false);
        } else {
          // Вернуть карточку в исходное положение
          setState(() {
            xOffset = 0;
            yOffset = 0;
            rotation = 0;
          });
        }
      },
      child: AnimatedContainer(
        duration: Duration(milliseconds: 300),
        transform: Matrix4.identity()
          ..translate(xOffset, yOffset)
          ..rotateZ(rotation),
        child: Card(
          margin: EdgeInsets.only(top: 40, left: 16, right: 16, bottom: 100),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(16),
          ),
          clipBehavior: Clip.antiAlias,
          child: Stack(
            children: [
              // Фоновое изображение профиля
              Image.network(
                person['image']!,
                height: double.infinity,
                width: double.infinity,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) {
                  return Container(
                    color: Colors.grey,
                    child: Center(
                      child: Icon(Icons.broken_image, size: 50, color: Colors.white),
                    ),
                  );
                },
              ),
              // Информация о профиле
              Align(
                alignment: Alignment.bottomLeft,
                child: Container(
                  color: Colors.black.withOpacity(0.6),
                  padding: EdgeInsets.all(16),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "${person['name']}, ${person['age']}",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        person['location']!,
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                        ),
                      ),
                      SizedBox(height: 8),
                      ElevatedButton(
                        onPressed: () {
                          // Логика для подключения
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.teal,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8.0),
                          ),
                        ),
                        child: Text("Connect"),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void handleSwipe(bool isRight) {
    setState(() {
      xOffset = isRight
          ? MediaQuery.of(context).size.width
          : -MediaQuery.of(context).size.width;
      yOffset = 0;
      rotation = 0.3 * (isRight ? 1 : -1);
    });

    Future.delayed(Duration(milliseconds: 300), () {
      setState(() {
        if (currentIndex < people.length - 1) {
          currentIndex++;
        } else {
          // Если это последняя карточка, ничего не делать или сбросить currentIndex
          currentIndex = 0; // Для зацикливания профилей
        }
        xOffset = 0;
        yOffset = 0;
        rotation = 0;
      });
    });
  }
}

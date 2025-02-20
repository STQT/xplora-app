import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'dart:math';

class MatchScreenPeople extends StatefulWidget {
  @override
  _MatchScreenPeopleState createState() => _MatchScreenPeopleState();
}

class _MatchScreenPeopleState extends State<MatchScreenPeople>
    with SingleTickerProviderStateMixin {
  final List<Map<String, String>> people = [
    {
      "name": "Jihan",
      "age": "20",
      "location": "London 29/10-31/10",
      "image": "https://picsum.photos/300?random=1",
      "interests":
      "Visiting museums, Playing and watching sports, Trying out new restaurants",
      "languages": "English, Urdu",
      "bio":
      "Hey! I’m Jihan, a 20-year-old college student heading to London for a conference...",
    },
    {
      "name": "Anel",
      "age": "21",
      "location": "New York 12/12-15/12",
      "image": "https://picsum.photos/300?random=2",
      "interests": "Reading books, Watching movies, Exploring cities",
      "languages": "English, French",
      "bio":
      "I’m Anel, a 21-year-old who loves books, movies, and city adventures...",
    },
  ];

  late AnimationController _animationController;
  late Animation<double> _flipAnimation;
  bool isShowingDetails = false;
  int currentIndex = 0;

  final CardSwiperController _swiperController = CardSwiperController();

  // Новая переменная для направления свайпа
  CardSwiperDirection? _lastSwipeDirection;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 400),
    );

    _flipAnimation = Tween<double>(begin: 0, end: pi).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleView() {
    if (isShowingDetails) {
      _animationController.reverse();
    } else {
      _animationController.forward();
    }
    setState(() {
      isShowingDetails = !isShowingDetails;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          AnimatedBuilder(
            animation: _flipAnimation,
            builder: (context, child) {
              return Transform(
                alignment: Alignment.center,
                transform: Matrix4.rotationY(_flipAnimation.value),
                child: _flipAnimation.value < pi / 2
                    ? _buildCardSwiper(context) // Передняя сторона (краткая инфо)
                    : Transform(
                  alignment: Alignment.center,
                  transform: Matrix4.rotationY(pi),
                  child: _buildDetailView(context), // Задняя сторона (детали)
                ),
              );
            },
          ),

          // Connect Button
          if (!isShowingDetails)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    _swiperController.swipe(CardSwiperDirection.right);
                    print("Liked ${people[currentIndex]['name']!}");
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF77C2C8),
                    fixedSize: Size(268, 48),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Text(
                    "Connect",
                    style: TextStyle(
                      fontFamily: 'Fira Sans Condensed',
                      fontSize: 16,
                      fontWeight: FontWeight.w400,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),

          // Оверлей с иконкой для визуальной индикации свайпа
          if (_lastSwipeDirection != null)
            Center(
              child: AnimatedOpacity(
                opacity: _lastSwipeDirection != null ? 1.0 : 0.0,
                duration: Duration(milliseconds: 300),
                child: Icon(
                  _lastSwipeDirection == CardSwiperDirection.right
                      ? Icons.favorite
                      : Icons.close,
                  color: _lastSwipeDirection == CardSwiperDirection.right
                      ? Colors.green
                      : Colors.red,
                  size: 100,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCardSwiper(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 80.0),
      child: Center(
        child: CardSwiper(
          cardsCount: people.length,
          controller: _swiperController,
          numberOfCardsDisplayed: 1,
          cardBuilder: (BuildContext context, int index, int _, int __) {
            final person = people[index];
            return Stack(
              children: [
                GestureDetector(
                  onTap: toggleView, // Переворачиваем карту при нажатии
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        Image.network(
                          person['image']!,
                          height: double.infinity,
                          width: double.infinity,
                          fit: BoxFit.cover,
                          errorBuilder: (context, error, stackTrace) {
                            return Container(
                              color: Colors.grey,
                              child: Center(
                                child: Icon(Icons.broken_image,
                                    size: 50, color: Colors.white),
                              ),
                            );
                          },
                        ),
                        Align(
                          alignment: Alignment.bottomCenter,
                          child: Container(
                            height: 150,
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.transparent,
                                  Colors.black.withOpacity(0.8),
                                ],
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                              ),
                            ),
                          ),
                        ),
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text(
                              "${person['name']}, ${person['age']}\n"
                                  "${person['location']}",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),

                // 🔹 Кнопка Switch (передняя сторона)
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: _buildSwitchButton(),
                ),
              ],
            );
          },
          onSwipe: (int index, int? previousIndex, CardSwiperDirection direction) {
            setState(() {
              currentIndex = index;
              _lastSwipeDirection = direction; // Запоминаем направление свайпа
            });

            // Показываем эффект на 500 мс и затем сбрасываем его
            Future.delayed(Duration(milliseconds: 500), () {
              setState(() {
                _lastSwipeDirection = null;
              });
            });

            if (direction == CardSwiperDirection.right) {
              print("Liked ${people[index]['name']!}");
            } else if (direction == CardSwiperDirection.left) {
              print("Skipped ${people[index]['name']!}");
            }
            return true;
          },
          padding: EdgeInsets.all(16),
          scale: 0.9,
        ),
      ),
    );
  }

  Widget _buildDetailView(BuildContext context) {
    final person = people[currentIndex];
    return GestureDetector(
      onTap: toggleView, // Переворачиваем обратно при нажатии
      child: Center(
        child: Container(
          width: 327,
          height: 441,
          decoration: BoxDecoration(
            color: Color(0xFF77C2C8),
            borderRadius: BorderRadius.circular(20),
          ),
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "${person['name']}, ${person['age']}",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Text("Interests", style: _headerStyle()),
              Text(person['interests']!, style: _textStyle()),
              Divider(color: Colors.white),
              Text("Languages", style: _headerStyle()),
              Text(person['languages']!, style: _textStyle()),
              // 🔹 Кнопка Switch (детальная сторона)
              Align(
                alignment: Alignment.bottomRight,
                child: _buildSwitchButton(),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchButton() {
    return ElevatedButton(
      onPressed: toggleView,
      style: ElevatedButton.styleFrom(
        backgroundColor: Colors.black54,
        shape: CircleBorder(),
        padding: EdgeInsets.all(12),
      ),
      child: Icon(Icons.flip, color: Colors.white, size: 24),
    );
  }

  TextStyle _headerStyle() =>
      TextStyle(fontSize: 16, fontWeight: FontWeight.bold, color: Colors.white);
  TextStyle _textStyle() =>
      TextStyle(fontSize: 14, color: Colors.white);
}

import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

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
      "image": "https://picsum.photos/300?random=1"
    },
    {
      "name": "Anel",
      "age": "21",
      "location": "New York 12/12-15/12",
      "image": "https://picsum.photos/300?random=2"
    },
    {
      "name": "Sofia",
      "age": "22",
      "location": "Paris 01/11-05/11",
      "image": "https://picsum.photos/300?random=3"
    },
    {
      "name": "Liam",
      "age": "24",
      "location": "Tokyo 10/12-15/12",
      "image": "https://picsum.photos/300?random=4"
    },
    {
      "name": "Emma",
      "age": "23",
      "location": "Berlin 20/12-25/12",
      "image": "https://picsum.photos/300?random=5"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Card Swiper
          Padding(
            padding: const EdgeInsets.only(bottom: 80.0), // Add padding for navigation bar
            child: Center(
              child: CardSwiper(
                cardsCount: people.length,
                cardBuilder: (BuildContext context, int index, int _, int __) {
                  final person = people[index];
                  return Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        // Profile Image
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
                        // Profile Info Over Image
                        Align(
                          alignment: Alignment.bottomLeft,
                          child: Container(
                            color: Colors.black.withOpacity(0.01),
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
                                    color: Colors.white70,
                                    fontSize: 16,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                  );
                },
                onSwipe: (int index, int? previousIndex, CardSwiperDirection direction) {
                  // Handle swipe actions
                  print("Swiped ${direction.name} on index $index");
                  return true; // Return true to allow swipe
                },
                padding: EdgeInsets.all(16),
                scale: 0.9,
              ),
            ),
          ),
          // Bottom Navigation Bar
          Align(
            alignment: Alignment.bottomCenter,
            child: BottomNavigationBar(
              currentIndex: 1, // Active tab is Match
              onTap: (index) {
                if (index == 0) {
                  Navigator.pushNamed(context, '/message'); // Go to Message screen
                } else if (index == 2) {
                  Navigator.pushNamed(context, '/profile'); // Go to Profile screen
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
}

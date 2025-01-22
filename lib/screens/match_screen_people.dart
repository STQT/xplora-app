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

  final CardSwiperController _swiperController = CardSwiperController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Card Swiper
          Padding(
            padding: const EdgeInsets.only(bottom: 140.0), // Add padding for button and navigation bar
            child: Center(
              child: CardSwiper(
                cardsCount: people.length,
                controller: _swiperController,
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
                  if (direction == CardSwiperDirection.left) {
                    showMessageSentAlert(context, people[index]['name']!);
                  }
                  return true; // Return true to allow swipe
                },
                padding: EdgeInsets.all(16),
                scale: 0.9,
              ),
            ),
          ),
          // Connect Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 80.0),
              child: ElevatedButton(
                onPressed: () {
                  // Swipe the current card to the left
                  _swiperController.swipe(CardSwiperDirection.left);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF20A090), // Updated backgroundColor
                  fixedSize: Size(268, 48), // Button size
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
        ],
      ),
    );
  }

  void showMessageSentAlert(BuildContext context, String name) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15, // Move it higher (30% of screen height)
              left: 20,
              right: 20,
              child: Container(
                height: 77,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [Color(0xFF5EBAAE), Color(0xFF24786D)],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                  border: Border.all(color: Color(0xFF43D590), width: 1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Icon(Icons.check_circle, size: 24, color: Colors.white),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Message sent",
                              style: TextStyle(
                                fontFamily: 'Fira Sans Condensed',
                                fontWeight: FontWeight.w600,
                                fontSize: 14,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "We’ll notify you when $name responds!",
                              style: TextStyle(
                                fontFamily: 'Fira Sans Condensed',
                                fontWeight: FontWeight.w400,
                                fontSize: 13,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => Navigator.of(context).pop(),
                      child: Padding(
                        padding: const EdgeInsets.all(12.0),
                        child: Icon(Icons.close, color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        );
      },
    );

    // Dismiss after 2 seconds
    Future.delayed(Duration(seconds: 1), () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }

}

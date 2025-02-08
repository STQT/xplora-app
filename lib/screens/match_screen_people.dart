import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';

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
      "interests": "Visiting museums, Playing and watching sports, Trying out new restaurants",
      "languages": "English, Urdu",
      "bio":
      "Hey! I’m Jihan, a 20-year-old college student heading to London for a conference. I’d love to meet other travelers, whether solo or in groups, to watch a football game together or grab some food. My instagram is @jihan.khann, feel free to add me there too!"
    },
    {
      "name": "Anel",
      "age": "21",
      "location": "New York 12/12-15/12",
      "image": "https://picsum.photos/300?random=2",
      "interests": "Reading books, Watching movies, Exploring cities",
      "languages": "English, French",
      "bio":
      "I’m Anel, a 21-year-old who loves books, movies, and city adventures. Let’s meet up for a chat or to explore the city together!"
    },
  ];

  late AnimationController _animationController;
  bool isShowingDetails = false;
  int currentIndex = 0;

  final CardSwiperController _swiperController = CardSwiperController();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: Duration(milliseconds: 300),
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

  void showMessageSentAlert(BuildContext context, String name) {
    showDialog(
      context: context,
      barrierDismissible: true, // Allows dismissing by tapping outside
      builder: (BuildContext context) {
        return GestureDetector(
          onTap: () {
            if (Navigator.of(context).canPop()) {
              Navigator.of(context).pop(); // Close the alert when tapping outside
            }
          },
          child: Stack(
            children: [
              Positioned(
                top: MediaQuery.of(context).size.height * 0.15,
                left: 20,
                right: 20,
                child: GestureDetector(
                  onTap: () {}, // Prevents the tap from propagating to the outer GestureDetector
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
                          onTap: () {
                            if (Navigator.of(context).canPop()) {
                              Navigator.of(context).pop(); // Close the alert
                            }
                          },
                          child: Padding(
                            padding: const EdgeInsets.all(12.0),
                            child: Icon(Icons.close, color: Colors.white),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );

    // Automatically dismiss after 2 seconds
    Future.delayed(Duration(milliseconds: 300), () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Flip Animation
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            child: isShowingDetails
                ? _buildDetailView(context)
                : _buildCardSwiper(context),
          ),
          // Connect Button
          if (!isShowingDetails)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    _swiperController.swipe(CardSwiperDirection.left);
                    showMessageSentAlert(
                        context, people[currentIndex]['name']!);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF20A090),
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
            return GestureDetector(
              onTap: () {
                setState(() {
                  currentIndex = index;
                  toggleView();
                });
              },
              child: Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                ),
                clipBehavior: Clip.antiAlias,
                child: Stack(
                  children: [
                    // Background Image
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
                    // Gradient Overlay
                    Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 150, // Высота градиента
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
                    // Text Information
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
            );
          },
          onSwipe: (int index, int? previousIndex, CardSwiperDirection direction) {
            if (direction == CardSwiperDirection.right) {
              print("Liked ${people[index]['name']!}");
              showMessageSentAlert(context, people[index]['name']!);
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
      onTap: toggleView,
      child: Center(
        child: Container(
          width: 327,
          height: 441,
          decoration: BoxDecoration(
            color: Color(0xFF20A090),
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
              Text(
                "Interests",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                person['interests']!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              Divider(color: Colors.white),
              Text(
                "Languages",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                person['languages']!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
              Divider(color: Colors.white),
              Text(
                "Bio",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              Text(
                person['bio']!,
                style: TextStyle(
                  fontSize: 14,
                  color: Colors.white,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
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
      duration: Duration(milliseconds: 600),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void toggleView() {
    setState(() {
      isShowingDetails = !isShowingDetails;
    });
  }

  void handleSwipeLeft() {
    if (currentIndex < people.length - 1) {
      setState(() {
        currentIndex++;
      });
    } else {
      // Optionally reset to the first card or handle the end of the list
      setState(() {
        currentIndex = 0; // Example: reset to the first card
      });
    }
  }

  Widget _buildProfileDetails(Map<String, String> person) {
    return Column(
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
        _buildDetailSection("Interests", person['interests']!),
        _buildDetailSection("Languages", person['languages']!),
        _buildDetailSection("Bio", person['bio']!),
      ],
    );
  }

  Widget _buildDetailSection(String title, String content) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: Colors.white,
          ),
        ),
        Text(
          content,
          style: TextStyle(
            fontSize: 14,
            color: Colors.white,
          ),
        ),
        Divider(color: Colors.white),
      ],
    );
  }

  Widget _buildConnectButton(BuildContext context, String name) {
    return Transform(
      alignment: Alignment.center,
      transform: Matrix4.identity(), // Исправлено: текст кнопки не переворачивается
      child: ElevatedButton(
        onPressed: () {
          handleSwipeLeft();
          showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text("Message Sent"),
                content: Text("You connected with $name!"),
                actions: <Widget>[
                  TextButton(
                    child: Text("OK"),
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                  ),
                ],
              );
            },
          );
        },
        style: ElevatedButton.styleFrom(
          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(24),
          ),
        ),
        child: Text(
          "Connect",
          style: TextStyle(fontSize: 16),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: isShowingDetails
            ? _buildDetailView(context)
            : _buildCardSwiper(context),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (isShowingDetails) {
            _animationController.reverse();
          } else {
            _animationController.forward();
          }
          toggleView();
        },
        child: Icon(Icons.swap_horiz),
      ),
    );
  }

  Widget _buildCardSwiper(BuildContext context) {
    return CardSwiper(
      cardsCount: people.length,
      controller: _swiperController,
      numberOfCardsDisplayed: 1,
      cardBuilder: (BuildContext context, int index, int _, int __) {
        final person = people[currentIndex];
        return Column(
          children: [
            Expanded(
              child: GestureDetector(
                onTap: () {
                  _animationController.forward();
                  toggleView();
                },
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
                      ),
                      Align(
                        alignment: Alignment.bottomLeft,
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Text(
                            "${person['name']}, ${person['age']}\n${person['location']}",
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
            ),
            SizedBox(height: 16),
            _buildConnectButton(context, person['name']!),
            SizedBox(height: 16),
          ],
        );
      },
    );
  }

  Widget _buildDetailView(BuildContext context) {
    final person = people[currentIndex];
    return GestureDetector(
      onTap: () {
        _animationController.reverse();
        toggleView();
      },
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 327,
            height: 441,
            decoration: BoxDecoration(
              color: Color(0xFF20A090),
              borderRadius: BorderRadius.circular(20),
            ),
            padding: EdgeInsets.all(16),
            child: _buildProfileDetails(person),
          ),
          SizedBox(height: 16),
          _buildConnectButton(context, person['name']!),
          SizedBox(height: 16),
        ],
      ),
    );
  }
}

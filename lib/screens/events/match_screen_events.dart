import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MatchScreenEvents extends StatefulWidget {
  @override
  _MatchScreenEventsState createState() => _MatchScreenEventsState();
}

class _MatchScreenEventsState extends State<MatchScreenEvents> {
  final List<Map<String, String>> events = [
    {
      "title": "Party in LA",
      "date": "09.10.2024",
      "attendees": "50",
      "image": "https://picsum.photos/300?random=2",
    },
    {
      "title": "Tech Conference",
      "date": "12.11.2024",
      "attendees": "200",
      "image": "https://picsum.photos/300?random=1",
    },
    // Add more events as needed
  ];

  final CardSwiperController _swiperController = CardSwiperController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 130.0, bottom: 70.0),
            // For top and bottom space
            child: Center(
              child: CardSwiper(
                cardsCount: events.length,
                controller: _swiperController,
                numberOfCardsDisplayed: 1,
                cardBuilder: (BuildContext context, int index, int _, int __) {
                  final event = events[index];
                  return Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20.0),
                    child: AspectRatio(
                      aspectRatio: 1, // Ensures a square-like aspect ratio
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: [
                            // Background Image
                            Image.network(
                              event['image']!,
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
                            // Gradient Overlay
                            Align(
                              alignment: Alignment.bottomCenter,
                              child: Container(
                                height: 150, // Height of the gradient overlay
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
                              child: Align(
                                alignment: Alignment.bottomLeft,
                                child: Padding(
                                  padding: const EdgeInsets.all(16.0),
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            event['title']!,
                                            style: TextStyle(
                                              fontFamily: 'Fira Sans Condensed',
                                              color: Colors.white,
                                              fontSize: 24,
                                            ),
                                          ),
                                          Text(
                                            "${event['date']}",
                                            style: TextStyle(
                                              fontFamily: 'Fira Sans Condensed',
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                      Column(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Row(
                                            children: [
                                              Icon(
                                                Icons.person,
                                                color: Colors.white,
                                                size: 24,
                                              ),
                                              SizedBox(width: 4),
                                              Text(
                                                "~${event['attendees']} attendees",
                                                style: TextStyle(
                                                  fontFamily: 'Fira Sans Condensed',
                                                  color: Colors.white,
                                                  fontSize: 20,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                            ),
                          ],
                        ),
                      ),
                    ),
                  );

                },
                onSwipe: (int index, int? previousIndex,
                    CardSwiperDirection direction) {
                  // Handle swipe actions if needed
                  print("Swiped ${direction.name} on index $index");
                  return true;
                },
                padding: EdgeInsets.zero,
                // Remove internal padding from CardSwiper
                scale: 0.9,
              ),
            ),
          ),

          // Top Buttons
          Positioned(
            top: 20,
            left: 20,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // Edit your events logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF20A090),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: SvgPicture.asset(
                          'assets/icons/create.svg',
                          width: 22,
                          height: 22,
                          color: Colors.white,
                        ),
                      ),

                      // SizedBox(width: 4),
                      Text("Create event",
                          style: TextStyle(
                              fontFamily: 'Fira Sans Condensed',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.white)),
                    ],
                  ),
                ),
                SizedBox(height: 4),
                ElevatedButton(
                  onPressed: () {
                    // Edit your events logic
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF20A090),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(right: 8.0),
                        child: SvgPicture.asset(
                          'assets/icons/edit.svg',
                          width: 24,
                          height: 24,
                          color: Colors.white,
                        ),
                      ),

                      // SizedBox(width: 4),
                      Text("Edit your events",
                          style: TextStyle(
                              fontFamily: 'Fira Sans Condensed',
                              fontWeight: FontWeight.w600,
                              fontSize: 14,
                              color: Colors.white)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          // Request to Join Button
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: ElevatedButton(
                onPressed: () {
                  // Request to join event logic
                  showRequestAlert(context);
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF20A090),
                  fixedSize: Size(268, 48),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
                child: Text(
                  "Request to join",
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w400,
                    fontFamily: 'Fira Sans Condensed',
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

  void showRequestAlert(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (BuildContext context) {
        return Stack(
          children: [
            Positioned(
              top: MediaQuery.of(context).size.height * 0.15,
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
                      child: Icon(Icons.check_circle,
                          size: 24, color: Colors.white),
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.only(right: 16.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              "Request sent",
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              "Your request to join has been sent!",
                              style: TextStyle(
                                fontSize: 13,
                                fontWeight: FontWeight.w400,
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

    // Auto-dismiss after 2 seconds
    Future.delayed(Duration(seconds: 2), () {
      if (Navigator.of(context).canPop()) {
        Navigator.of(context).pop();
      }
    });
  }
}

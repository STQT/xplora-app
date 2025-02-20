import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:discoveria/screens/events/create_event.dart';
import 'package:discoveria/screens/events/request_screen.dart';

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
  ];

  final CardSwiperController _swiperController = CardSwiperController();
  int currentIndex = 0; // ✅ Храним текущий индекс
  CardSwiperDirection? _lastSwipeDirection; // Направление последнего свайпа

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100.0, bottom: 100.0),
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
                      aspectRatio: 1,
                      child: Card(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(16),
                        ),
                        clipBehavior: Clip.antiAlias,
                        child: Stack(
                          children: [
                            Image.network(
                              event['image']!,
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
                                child: Row(
                                  mainAxisAlignment:
                                  MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                      CrossAxisAlignment.start,
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
                                                fontFamily:
                                                'Fira Sans Condensed',
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
                          ],
                        ),
                      ),
                    ),
                  );
                },
                onSwipe: (int index, int? previousIndex,
                    CardSwiperDirection direction) {
                  setState(() {
                    currentIndex = index;
                    _lastSwipeDirection = direction; // Запоминаем направление свайпа
                  });

                  // Показываем эффект на 500мс, затем очищаем эффект и (если лайк) переходим на следующий экран.
                  Future.delayed(Duration(milliseconds: 500), () {
                    setState(() {
                      _lastSwipeDirection = null;
                    });
                    if (direction == CardSwiperDirection.right) {
                      final selectedEvent = events[currentIndex];
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => RequestToJoinEventScreen(
                            eventName: selectedEvent['title']!,
                            eventDate: selectedEvent['date']!,
                          ),
                        ),
                      );
                    }
                  });
                  return true;
                },
                padding: EdgeInsets.zero,
                scale: 0.9,
              ),
            ),
          ),

          // Кнопки в верхнем левом углу
          Positioned(
            top: 20,
            left: 20,
            child: Row(
              children: [
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateEventScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF77C2C8),
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
                      Text(
                        "Create event",
                        style: TextStyle(
                          fontFamily: 'Fira Sans Condensed',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(width: 16),
                ElevatedButton(
                  onPressed: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => CreateEventScreen()),
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Color(0xFF77C2C8),
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
                      Text(
                        "Edit your events",
                        style: TextStyle(
                          fontFamily: 'Fira Sans Condensed',
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),

          // Кнопка в нижней части экрана
          Align(
            alignment: Alignment.bottomCenter,
            child: Padding(
              padding: const EdgeInsets.only(bottom: 50.0),
              child: ElevatedButton(
                onPressed: () {
                  final selectedEvent = events[currentIndex];
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => RequestToJoinEventScreen(
                        eventName: selectedEvent['title']!,
                        eventDate: selectedEvent['date']!,
                      ),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color(0xFF77C2C8),
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
}

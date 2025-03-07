import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:discoveria/screens/events/create_event.dart';
import 'package:discoveria/screens/events/request_screen.dart';

import '../../constants/auth.dart';

class Event {
  final String id;
  final String title;
  final String eventDate;
  final int cntPeople;
  final String eventImg;
  final String address;
  final String description;
  final String cityName;

  Event({
    required this.id,
    required this.title,
    required this.eventDate,
    required this.cntPeople,
    required this.eventImg,
    required this.address,
    required this.description,
    required this.cityName,
  });

  factory Event.fromJson(Map<String, dynamic> json) {
    return Event(
      id: json['id'] ?? '',
      title: json['title'] ?? '',
      eventDate: json['event_date'] ?? '',
      cntPeople: json['cnt_people'] is int
          ? json['cnt_people']
          : int.tryParse(json['cnt_people'].toString()) ?? 0,
      eventImg: json['event_img'] ?? '',
      address: json['address'] ?? '',
      description: json['description'] ?? '',
      cityName: json['city']?['name'] ?? '',
    );
  }
}

class MatchScreenEvents extends StatefulWidget {
  @override
  _MatchScreenEventsState createState() => _MatchScreenEventsState();
}

class _MatchScreenEventsState extends State<MatchScreenEvents> {
  List<Event> events = [];
  String? nextPageUrl = 'https://xplora.robosoft.kz/api/events/';
  bool isLoading = false;

  final CardSwiperController _swiperController = CardSwiperController();
  int currentIndex = 0;
  CardSwiperDirection? _lastSwipeDirection;

  @override
  void initState() {
    super.initState();
    _loadEvents();
  }

  Future<void> _loadEvents() async {
    if (nextPageUrl == null || isLoading) return;

    setState(() {
      isLoading = true;
    });

    // Получаем токен из shared_preferences (если он используется)
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AuthConst.tokenKey);

    try {
      final response = await http.get(
        Uri.parse(nextPageUrl!),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> results = data['results'] ?? [];
        List<Event> loadedEvents =
        results.map((json) => Event.fromJson(json)).toList();
        setState(() {
          events.addAll(loadedEvents);
          nextPageUrl = data['next']; // если null – пагинация окончена
        });
      } else {
        print('Ошибка: ${response.statusCode}');
      }
    } catch (e) {
      print('Ошибка загрузки событий: $e');
    }
    setState(() {
      isLoading = false;
    });
  }

  // Проверяем необходимость подгрузки следующей страницы (например, когда осталось 1-2 события)
  void _checkPagination(int index) {
    if (index >= events.length - 2 && nextPageUrl != null) {
      _loadEvents();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Если события ещё не загружены, показываем индикатор загрузки.
    if (events.isEmpty && isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

    return Scaffold(
      body: Stack(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 100.0, bottom: 100.0),
            child: Center(
              child: CardSwiper(
                cardsCount: events.length,
                controller: _swiperController,
                numberOfCardsDisplayed: events.isEmpty ? 0 : 1,
                cardBuilder: (BuildContext context, int index, int _, int __) {
                  _checkPagination(index);
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
                              event.eventImg,
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
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          Text(
                                            event.title,
                                            style: TextStyle(
                                              fontFamily: 'Fira Sans Condensed',
                                              color: Colors.white,
                                              fontSize: 24,
                                            ),
                                          ),
                                          Text(
                                            event.eventDate,
                                            style: TextStyle(
                                              fontFamily: 'Fira Sans Condensed',
                                              color: Colors.white,
                                              fontSize: 20,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Expanded(
                                      child: Row(
                                        mainAxisAlignment: MainAxisAlignment.end,
                                        children: [
                                          Icon(
                                            Icons.person,
                                            color: Colors.white,
                                            size: 24,
                                          ),
                                          SizedBox(width: 4),
                                          Flexible(
                                            child: Text(
                                              "~${event.cntPeople} attendees",
                                              overflow: TextOverflow.ellipsis,
                                              style: TextStyle(
                                                fontFamily: 'Fira Sans Condensed',
                                                color: Colors.white,
                                                fontSize: 20,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
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
                onSwipe: (int index, int? previousIndex, CardSwiperDirection direction) {
                  setState(() {
                    currentIndex = index;
                    _lastSwipeDirection = direction;
                  });

                  // После 500мс, сбрасываем визуальный эффект и, если свайп вправо – переходим на экран заявки.
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
                            eventName: selectedEvent.title,
                            eventDate: selectedEvent.eventDate,
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
          // Верхние кнопки: создание события и редактирование
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
                        "My events",
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
          // Кнопка в нижней части экрана для заявки на участие
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
                        eventName: selectedEvent.title,
                        eventDate: selectedEvent.eventDate,
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

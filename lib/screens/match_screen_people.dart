import 'dart:convert';
import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_card_swiper/flutter_card_swiper.dart';
import 'package:http/http.dart' as http;
import 'package:discoveria/constants/constants.dart';
import 'package:shared_preferences/shared_preferences.dart';

// Пример модели для профиля
class Profile {
  final String name;
  final String age; // Можно вычислять возраст по дате рождения
  final String
      location; // Здесь можно составить строку на основе city, date_start/date_end или других полей
  final String image;
  final String interests;
  final String languages;
  final String bio;
  final String userId;

  Profile(
      {required this.userId,
      required this.name,
      required this.age,
      required this.location,
      required this.image,
      required this.interests,
      required this.languages,
      required this.bio});

  factory Profile.fromJson(Map<String, dynamic> json) {
    // Пример преобразования: используем firstname как name, можно допилить расчет возраста и location
    return Profile(
      userId: json['user_id'] ?? '',
      name: json['firstname'] ?? '',
      age: json['birth_date'] ?? '',
      location: json['city']?['name'] ?? '',
      image: json['profile_img'] ?? '',
      interests: (json['interests'] as List<dynamic>?)
              ?.map((e) => e['name'])
              .join(', ') ??
          '',
      languages: (json['languages'] as List<dynamic>?)
              ?.map((e) => e['name'])
              .join(', ') ??
          '',
      bio: json['bio'] ?? '',
    );
  }
}

class MatchScreenPeople extends StatefulWidget {
  @override
  _MatchScreenPeopleState createState() => _MatchScreenPeopleState();
}

class _MatchScreenPeopleState extends State<MatchScreenPeople>
    with SingleTickerProviderStateMixin {
  List<Profile> profiles = [];
  String? nextPageUrl =
      'https://xplora.robosoft.kz/api/users/profiles/?limit=1';
  bool isLoading = false;

  late AnimationController _animationController;
  late Animation<double> _flipAnimation;
  bool isShowingDetails = false;
  int currentIndex = 0;

  final CardSwiperController _swiperController = CardSwiperController();
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
    _loadProfiles(); // загрузка первой страницы
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  // Функция для загрузки данных с API с учетом пагинации
  Future<void> _loadProfiles() async {
    if (isLoading) {
      print("🔄 Загрузка уже идет, пропускаем...");
      return;
    }

    setState(() {
      isLoading = true;
    });

    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AuthConst.tokenKey);

    if (token == null) {
      print("❌ Ошибка: Токен не найден в SharedPreferences.");
      setState(() => isLoading = false);
      return;
    }

    print("📡 Отправляем запрос на загрузку профиля...");

    try {
      final url = 'https://xplora.robosoft.kz/api/users/profiles/?limit=1';
      final response = await http.get(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      print("✅ Ответ от сервера (${response.statusCode}): ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> results = data['results'] ?? [];

        setState(() {
          profiles.clear(); // Очистка списка
          if (results.isNotEmpty) {
            profiles.add(Profile.fromJson(results.first));
            print("🆕 Загружен новый профиль: ${profiles.first.name}");
          } else {
            print("⚠️ Нет новых профилей.");
          }
        });
      } else {
        print('❌ Ошибка загрузки профилей: ${response.statusCode}');
      }
    } catch (e) {
      print('❌ Ошибка сети: $e');
    }

    setState(() {
      isLoading = false;
    });
  }

  Future<void> _sendSwipeRequest(Profile profile, String status) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AuthConst.tokenKey);

    if (token == null) {
      print("❌ Ошибка: Токен не найден в SharedPreferences.");
      return;
    }

    final url = 'https://xplora.robosoft.kz/api/user-requests/';
    final body = jsonEncode({
      "user_id": profile.userId,
      "status": status,
    });

    print(
        "📡 Отправляем запрос на свайп ($status) для пользователя: ${profile.name}");
    print("➡️ URL: $url");
    print("📤 Тело запроса: $body");

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: body,
      );

      print("✅ Ответ от сервера (${response.statusCode}): ${response.body}");

      if (response.statusCode == 200 || response.statusCode == 201) {
        print("🎉 Запрос отправлен успешно!");
      } else {
        print("❌ Ошибка при отправке запроса: ${response.statusCode}");
      }
    } catch (e) {
      print("❌ Ошибка сети: $e");
    }
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

  // Функция, которая проверяет, нужно ли подгружать следующую страницу,
  // например, когда пользователь дойдет до предпоследней карточки
  void _checkPagination(int index) {
    if (index >= profiles.length - 2 && nextPageUrl != null) {
      _loadProfiles();
    }
  }

  @override
  Widget build(BuildContext context) {
    // Если профили ещё не загружены, можно показать индикатор загрузки
    if (profiles.isEmpty && isLoading) {
      return Scaffold(
        body: Center(child: CircularProgressIndicator()),
      );
    }

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
                    ? _buildCardSwiper(context)
                    : Transform(
                        alignment: Alignment.center,
                        transform: Matrix4.rotationY(pi),
                        child: _buildDetailView(context),
                      ),
              );
            },
          ),
          if (!isShowingDetails)
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: const EdgeInsets.only(bottom: 10.0),
                child: ElevatedButton(
                  onPressed: () {
                    _swiperController.swipe(CardSwiperDirection.right);
                    print("Liked ${profiles[currentIndex].name}");
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
    if (profiles.isEmpty) {
      return Center(
        child: isLoading
            ? CircularProgressIndicator() // Показываем индикатор загрузки
            : Text("Нет доступных профилей", style: TextStyle(fontSize: 18)),
      );
    }
    return Padding(
      padding: const EdgeInsets.only(bottom: 80.0),
      child: Center(
        child: CardSwiper(
          cardsCount: profiles.length,
          controller: _swiperController,
          numberOfCardsDisplayed: 1,
          cardBuilder: (BuildContext context, int index, int _, int __) {
            // Проверяем пагинацию
            _checkPagination(index);
            final profile = profiles[index];
            return Stack(
              children: [
                GestureDetector(
                  onTap: toggleView,
                  child: Card(
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                    clipBehavior: Clip.antiAlias,
                    child: Stack(
                      children: [
                        Image.network(
                          profile.image,
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
                              "${profile.name}, ${profile.age}\n${profile.location}",
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
                Positioned(
                  bottom: 16,
                  right: 16,
                  child: _buildSwitchButton(),
                ),
              ],
            );
          },
          onSwipe:
              (int index, int? previousIndex, CardSwiperDirection direction) {
            if (profiles.isEmpty) return false;

            final profile = profiles[0];
            final status =
                direction == CardSwiperDirection.right ? "wait" : "deny";

            print(
                "💨 Свайп ${direction == CardSwiperDirection.right ? "➡️ ЛАЙК" : "❌ ДИЗЛАЙК"} для ${profile.name}");

            setState(() {
              _lastSwipeDirection = direction;
            });

            Future.delayed(Duration(milliseconds: 500), () {
              setState(() {
                _lastSwipeDirection = null;
              });
            });

            _sendSwipeRequest(profile, status).then((_) {
              setState(() {
                profiles.clear();
                isLoading = false; // <---- Добавлено! Сбрасываем блокировку
              });
              _loadProfiles(); // Загружаем новый профиль
            });

            return true; // Подтверждаем свайп
          },
          padding: EdgeInsets.all(16),
          scale: 0.9,
        ),
      ),
    );
  }

  Widget _buildDetailView(BuildContext context) {
    final profile = profiles[currentIndex];
    return GestureDetector(
      onTap: toggleView,
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
                "${profile.name}, ${profile.age}",
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: Colors.white,
                ),
              ),
              SizedBox(height: 16),
              Text("Interests", style: _headerStyle()),
              Text(profile.interests, style: _textStyle()),
              Divider(color: Colors.white),
              Text("Languages", style: _headerStyle()),
              Text(profile.languages, style: _textStyle()),
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

  TextStyle _textStyle() => TextStyle(fontSize: 14, color: Colors.white);
}

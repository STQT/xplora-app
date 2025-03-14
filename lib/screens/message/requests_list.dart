import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/auth.dart';
import 'package:discoveria/screens/message/request_screen.dart';

class RequestsListScreen extends StatefulWidget {
  @override
  _RequestsListScreenState createState() => _RequestsListScreenState();
}

class _RequestsListScreenState extends State<RequestsListScreen> {
  bool showPeople = true; // Переключатель между People и Events
  late Future<List<dynamic>> futurePeopleRequests;
  late Future<List<dynamic>> futureEventRequests;

  @override
  void initState() {
    super.initState();
    futurePeopleRequests = fetchPeopleRequests();
    futureEventRequests = fetchEventRequests();
  }

  /// Запрос на получение PEOPLE-запросов
  Future<List<dynamic>> fetchPeopleRequests() async {
    final url = 'https://xplora.robosoft.kz/api/users/profiles/requests/';
    return await fetchRequests(url);
  }

  /// Запрос на получение EVENT-запросов
  Future<List<dynamic>> fetchEventRequests() async {
    final url = 'https://xplora.robosoft.kz/api/events/requests/';
    return await fetchRequests(url);
  }

  /// Универсальная функция для запроса данных
  Future<List<dynamic>> fetchRequests(String url) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AuthConst.tokenKey);
    final response = await http.get(
      Uri.parse(url),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final Map<String, dynamic> data = json.decode(response.body);
      return data['results'] ?? [];
    } else {
      throw Exception('Ошибка загрузки данных');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        // Переключатель "Events" / "People"
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildToggleButton("Events", !showPeople),
              _buildToggleButton("People", showPeople),
            ],
          ),
        ),

        // Контентная область
        Expanded(
          child: FutureBuilder<List<dynamic>>(
            future: showPeople ? futurePeopleRequests : futureEventRequests,
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
                return Center(child: Text('No requests available'));
              }

              final requests = snapshot.data!;

              return ListView.builder(
                padding: EdgeInsets.all(16),
                itemCount: requests.length,
                itemBuilder: (context, index) {
                  final request = requests[index];

                  // Для People-запросов
                  if (showPeople) {
                    return _buildPeopleRequestTile(request);
                  }

                  // Для Event-запросов
                  else {
                    return _buildEventRequestTile(request);
                  }
                },
              );
            },
          ),
        ),
      ],
    );
  }

  /// Виджет кнопки переключения
  Widget _buildToggleButton(String title, bool isActive) {
    return GestureDetector(
      onTap: () {
        setState(() {
          showPeople = title == "People";
        });
      },
      child: Column(
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.bold,
              color: isActive ? Color(0xFF77C2C8) : Colors.black54,
            ),
          ),
          if (isActive)
            Container(
              margin: EdgeInsets.only(top: 4),
              height: 2,
              width: 40,
              color: Color(0xFF77C2C8),
            ),
        ],
      ),
    );
  }

  /// Виджет элемента списка для People-запроса
  Widget _buildPeopleRequestTile(Map<String, dynamic> request) {
    final userName = '${request['firstname']} ${request['lastname']}';
    final requestMessage = 'Requests to join your party on ${request['date_start']}';
    final userId = request['user_id'] ?? '';

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          request['profile_img'] != null && request['profile_img'].toString().isNotEmpty
              ? request['profile_img']
              : 'https://picsum.photos/150?random=1',
        ),
      ),
      title: Text(
        userName,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(requestMessage),
      trailing: Icon(Icons.remove_red_eye, color: Color(0xFF77C2C8)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RequestScreen(
              userId: userId,
              userName: userName,
              userImage: request['profile_img'] ?? 'https://picsum.photos/150?random=1',
              requestMessage: requestMessage + "\n\n" + (request['bio'] ?? ''),
              requestTime: request['date_start'] ?? '',
            ),
          ),
        );
      },
    );
  }

  /// Виджет элемента списка для Event-запроса
  Widget _buildEventRequestTile(Map<String, dynamic> request) {
    final userName = '${request['firstname']} ${request['lastname']}';
    final userId = request['user_id'] ?? '';
    final event = request['event'][0]; // Получаем первый (и единственный) объект события
    final eventName = event['title'] ?? 'Unknown Event';
    final eventDate = event['event_date'] ?? 'Unknown Date';
    final eventAddress = event['address'] ?? 'Unknown Address';

    final requestMessage = '$userName wants to join "$eventName" on $eventDate at $eventAddress';

    return ListTile(
      leading: CircleAvatar(
        backgroundImage: NetworkImage(
          request['profile_img'] != null && request['profile_img'].toString().isNotEmpty
              ? request['profile_img']
              : 'https://picsum.photos/150?random=1',
        ),
      ),
      title: Text(
        userName,
        style: TextStyle(fontWeight: FontWeight.bold),
      ),
      subtitle: Text(requestMessage),
      trailing: Icon(Icons.remove_red_eye, color: Color(0xFF77C2C8)),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => RequestScreen(
              userId: userId,
              userName: userName,
              userImage: request['profile_img'] ?? 'https://picsum.photos/150?random=1',
              requestMessage: requestMessage + "\n\n" + (request['bio'] ?? ''),
              requestTime: eventDate,
            ),
          ),
        );
      },
    );
  }
}

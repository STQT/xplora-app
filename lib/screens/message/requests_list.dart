import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:discoveria/screens/message/request_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/auth.dart';

class RequestsListScreen extends StatefulWidget {
  @override
  _RequestsListScreenState createState() => _RequestsListScreenState();
}

class _RequestsListScreenState extends State<RequestsListScreen> {
  Future<List<dynamic>> fetchRequests() async {
    final url = 'https://xplora.robosoft.kz/api/users/profiles/requests/';
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
      final List<dynamic> requests = data['results'];
      return requests;
    } else {
      throw Exception('Ошибка загрузки данных');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchRequests(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Error: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Empty requests'));
        } else {
          final requests = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: requests.length,
            itemBuilder: (context, index) {
              final request = requests[index];
              // Формируем полное имя пользователя
              final userName = '${request['firstname']} ${request['lastname']}';
              // Пример формирования сообщения. Можно использовать поле bio или дату начала события.
              final requestMessage =
                  'Request to join your event on ${request['date_start']}';
              // Можно отобразить дату запроса или дату начала мероприятия
              final requestTime = request['date_start'] ?? '';
              // Получаем user_id из запроса
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
                        userImage: request['profile_img'] != null && request['profile_img'].toString().isNotEmpty
                            ? request['profile_img']
                            : 'https://picsum.photos/150?random=1',
                        requestMessage: requestMessage +
                            "\n\n" +
                            (request['bio'] ?? ''),
                        requestTime: requestTime,
                      ),
                    ),
                  );
                },
              );
            },
          );
        }
      },
    );
  }
}

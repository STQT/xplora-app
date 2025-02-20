import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/auth.dart';
import 'chat_screen.dart';

class MessagesListScreen extends StatefulWidget {
  @override
  _MessagesListScreenState createState() => _MessagesListScreenState();
}

class _MessagesListScreenState extends State<MessagesListScreen> {
  Future<List<dynamic>> fetchChats() async {
    final url = 'https://xplora.robosoft.kz/api/chats/';
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
      List<dynamic> data = json.decode(response.body);
      print(data);
      return data;
    } else {
      throw Exception('Ошибка загрузки данных');
    }
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<dynamic>>(
      future: fetchChats(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text('Ошибка: ${snapshot.error}'));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return Center(child: Text('Нет сообщений'));
        } else {
          final chats = snapshot.data!;
          return ListView.builder(
            padding: EdgeInsets.all(16),
            itemCount: chats.length,
            itemBuilder: (context, index) {
              final chat = chats[index];

              // Проверяем наличие user_profile
              final userProfile = chat['user_profile'];
              String userName = "Unknown";
              String userImage = 'https://picsum.photos/150';
              if (userProfile != null) {
                userName = '${userProfile['firstname'] ?? ''} ${userProfile['lastname'] ?? ''}'
                    .trim();
                if (userProfile['profile_img'] != null &&
                    userProfile['profile_img'].toString().isNotEmpty) {
                  userImage = userProfile['profile_img'];
                }
              }

              // Обработка last_message, если оно не null
              final lastMessage = chat['last_message'];
              String messageText = "";
              String timeAgo = "";
              if (lastMessage != null) {
                messageText = lastMessage['text'] ?? "";
                if (lastMessage['created_at'] != null) {
                  try {
                    final createdAt = DateTime.parse(lastMessage['created_at']);
                    timeAgo =
                    '${DateTime.now().difference(createdAt).inMinutes} мин назад';
                  } catch (e) {
                    timeAgo = "";
                  }
                }
              }

              return InkWell(
                onTap: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatScreen(
                        chatId: chat['chat_id'] ?? '',
                        userName: userName,
                        userImage: userImage,
                      ),
                    ),
                  );
                },
                child: ListTile(
                  leading: CircleAvatar(
                    backgroundImage: NetworkImage(userImage),
                  ),
                  title: Text(
                    userName,
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  subtitle: Text(messageText),
                  trailing: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(timeAgo, style: TextStyle(fontSize: 12)),
                      // Дополнительная логика для индикатора непрочитанных сообщений
                    ],
                  ),
                ),
              );
            },
          );
        }
      },
    );
  }
}

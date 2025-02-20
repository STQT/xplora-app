import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../constants/auth.dart';

class ChatScreen extends StatefulWidget {
  final String chatId;
  final String userName;
  final String userImage;

  ChatScreen({
    required this.chatId,
    required this.userName,
    required this.userImage,
  });

  @override
  _ChatScreenState createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ChatScreen> {
  List<dynamic> messages = [];
  String? nextPageUrl;
  bool isLoading = false;
  ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    fetchMessages();
    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200 &&
          nextPageUrl != null &&
          !isLoading) {
        fetchMessages(url: nextPageUrl);
      }
    });
  }

  Future<void> fetchMessages({String? url}) async {
    setState(() {
      isLoading = true;
    });
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString(AuthConst.tokenKey);
    // Если url не задан, используем начальный endpoint с chatId
    final requestUrl = url ??
        'https://xplora.robosoft.kz/api/chats/${widget.chatId}/';
    final response = await http.get(
      Uri.parse(requestUrl),
      headers: {
        'Authorization': 'Bearer $token',
        'Content-Type': 'application/json',
      },
    );

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      // data содержит поля count, next, previous, results
      setState(() {
        messages.addAll(data['results']);
        nextPageUrl = data['next'];
      });
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Ошибка загрузки сообщений')),
      );
    }
    setState(() {
      isLoading = false;
    });
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  // Виджет сообщения, аналогичный вашему предыдущему коду
  Widget _buildMessageBubble({
    required String text,
    required bool isSender,
    required String time,
  }) {
    return Align(
      alignment: isSender ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment:
        isSender ? CrossAxisAlignment.end : CrossAxisAlignment.start,
        children: [
          Container(
            padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
            margin: EdgeInsets.symmetric(vertical: 4),
            decoration: BoxDecoration(
              color: isSender ? Color(0xFF77C2C8) : Colors.grey.shade200,
              borderRadius: BorderRadius.circular(16),
            ),
            child: Text(
              text,
              style: TextStyle(
                fontSize: 14,
                color: isSender ? Colors.white : Colors.black,
              ),
            ),
          ),
          Padding(
            padding: EdgeInsets.only(
                right: isSender ? 8 : 0, left: isSender ? 0 : 8),
            child: Text(
              time,
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  // Простейшее поле ввода сообщения
  Widget _buildMessageInputField() {
    return Container(
      padding: EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [
          IconButton(
            icon: Icon(Icons.attachment, color: Colors.black),
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: TextField(
                decoration: InputDecoration(
                  hintText: "Write your message",
                  border: InputBorder.none,
                ),
              ),
            ),
          ),
          IconButton(
            icon: Icon(Icons.camera_alt, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: Icon(Icons.mic, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        title: Row(
          children: [
            CircleAvatar(
              backgroundImage: NetworkImage(widget.userImage),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.userName,
                  style: TextStyle(
                    fontFamily: 'Fira Sans Condensed',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                Text(
                  "Active now",
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.green,
                  ),
                ),
              ],
            ),
          ],
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Column(
        children: [
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: EdgeInsets.all(16),
              itemCount: messages.length + 1, // дополнительный элемент для индикатора загрузки
              itemBuilder: (context, index) {
                if (index == messages.length) {
                  return isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox.shrink();
                }
                final message = messages[index];
                // Определяем, кто отправитель. Для этого можно сравнить sender_id с текущим userId.
                // Здесь можно добавить логику получения currentUserId.
                // В данном примере просто считаем, что все сообщения получены от собеседника.
                final isSender = false;
                final text = message['text'] ?? "";
                String time = "";
                if (message['created_at'] != null) {
                  try {
                    final createdAt = DateTime.parse(message['created_at']);
                    time =
                    '${createdAt.hour}:${createdAt.minute.toString().padLeft(2, '0')}';
                  } catch (e) {
                    time = "";
                  }
                }
                return _buildMessageBubble(text: text, isSender: isSender, time: time);
              },
            ),
          ),
          _buildMessageInputField(),
        ],
      ),
    );
  }
}

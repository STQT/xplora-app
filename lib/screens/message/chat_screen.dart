import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class ChatScreen extends StatelessWidget {
  final String userName;
  final String userImage;

  ChatScreen({required this.userName, required this.userImage});

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
              backgroundImage: NetworkImage(userImage),
            ),
            SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  userName,
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
            child: ListView(
              padding: EdgeInsets.all(16),
              children: [
                _buildDateLabel("Today"),
                _buildMessageBubble(
                    text: "Hey! How are you doing?",
                    isSender: false,
                    time: "09:25 AM"),
                _buildMessageBubble(
                    text: "Hello, John Smith!!!",
                    isSender: true,
                    time: "09:25 AM"),
                _buildMessageBubble(
                    text: "You did your job well!",
                    isSender: true,
                    time: "09:25 AM"),
                _buildMessageBubble(
                    text: "Have a great week!",
                    isSender: false,
                    time: "09:25 AM"),
                _buildMessageBubble(
                    text: "See you soon!", isSender: false, time: "09:25 AM"),
                _buildVoiceMessage(time: "09:25 AM"),
              ],
            ),
          ),
          _buildMessageInputField(),
        ],
      ),
    );
  }

  Widget _buildDateLabel(String date) {
    return Center(
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 12, vertical: 6),
        decoration: BoxDecoration(
          color: Colors.grey.shade300,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Text(
          date,
          style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(
      {required String text, required bool isSender, required String time}) {
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
              color: isSender ? Color(0xFF20A090) : Colors.grey.shade200,
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
            padding: EdgeInsets.only(right: isSender ? 8 : 0, left: isSender ? 0 : 8),
            child: Text(
              time,
              style: TextStyle(fontSize: 10, color: Colors.grey),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoiceMessage({required String time}) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        padding: EdgeInsets.all(10),
        margin: EdgeInsets.symmetric(vertical: 4),
        decoration: BoxDecoration(
          color: Color(0xFF20A090),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.play_arrow, color: Colors.white, size: 28),
            SizedBox(width: 8),
            Container(
              width: 100,
              height: 4,
              decoration: BoxDecoration(
                color: Colors.white70,
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            SizedBox(width: 8),
            Text(
              "00:16",
              style: TextStyle(fontSize: 12, color: Colors.white),
            ),
          ],
        ),
      ),
    );
  }

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
            icon: SvgPicture.asset("assets/icons/attachment.svg",
                width: 22, height: 22, color: Colors.black),
            onPressed: () {},
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                color: Colors.grey.shade200,
                borderRadius: BorderRadius.circular(24),
              ),
              padding: EdgeInsets.symmetric(horizontal: 12),
              child: Row(
                children: [
                  Expanded(
                    child: TextField(
                      decoration: InputDecoration(
                        hintText: "Write your message",
                        hintStyle: TextStyle(
                          fontFamily: 'Fira Sans Condensed', // Указан шрифт
                          fontSize: 14, // Размер шрифта
                          color: Colors.grey, // Цвет текста
                        ),
                        border: InputBorder.none, // Убираем стандартную границу
                      ),
                      style: TextStyle(
                        fontFamily: 'Fira Sans Condensed', // Применение шрифта к тексту
                        fontSize: 16, // Размер шрифта для ввода текста
                        color: Colors.black, // Цвет вводимого текста
                      ),
                    ),
                  ),
                  IconButton(
                    icon: SvgPicture.asset("assets/icons/sticker.svg",
                        width: 20, height: 20, color: Colors.black),
                    onPressed: () {},
                  ),
                ],
              ),
            ),
          ),
          IconButton(
            icon: SvgPicture.asset("assets/icons/camera.svg",
                width: 24, height: 24, color: Colors.black),
            onPressed: () {},
          ),
          IconButton(
            icon: SvgPicture.asset("assets/icons/mic.svg",
                width: 24, height: 24, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
    );
  }
}

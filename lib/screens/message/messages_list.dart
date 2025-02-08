import 'package:flutter/material.dart';
import 'chat_screen.dart';

class MessagesListScreen extends StatelessWidget {
  final List<Map<String, String>> messages = [
    {
      "name": "Alex Linderson",
      "message": "How are you today?",
      "time": "2 min ago",
      "unread": "3",
      "image": "https://picsum.photos/150?random=1"
    },
    {
      "name": "LA party 09.10",
      "message": "Make sure to attend the meeting!",
      "time": "2 min ago",
      "unread": "4",
      "image": "https://picsum.photos/150?random=2"
    },
    {
      "name": "John Smith",
      "message": "Hey! How are you doing?",
      "time": "5 min ago",
      "unread": "2",
      "image": "https://picsum.photos/150?random=3"
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return InkWell(
          onTap: () {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ChatScreen(
                  userName: message['name']!,
                  userImage: message['image']!,
                ),
              ),
            );
          },
          child: ListTile(
            leading: CircleAvatar(
              backgroundImage: NetworkImage(message['image']!),
            ),
            title: Text(
              message['name']!,
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Text(message['message']!),
            trailing: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text(message['time']!, style: TextStyle(fontSize: 12)),
                if (message['unread'] != null)
                  SizedBox(height: 5),
                if (message['unread'] != null)
                  CircleAvatar(
                    radius: 12,
                    backgroundColor: Color(0xFF77C2C8),
                    child: Text(
                      message['unread']!,
                      style: TextStyle(color: Colors.white, fontSize: 12),
                    ),
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}

import 'package:flutter/material.dart';

class MessagesListScreen extends StatelessWidget {
  final List<Map<String, String>> messages = [
    {
      "name": "Alex Linderson",
      "message": "How are you today?",
      "time": "2 min ago",
      "unread": "3",
    },
    {
      "name": "LA party 09.10",
      "message": "Make sure to attend the meeting!",
      "time": "2 min ago",
      "unread": "4",
    },
    // Добавьте другие сообщения
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: messages.length,
      itemBuilder: (context, index) {
        final message = messages[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://picsum.photos/150?random=2'),
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
                CircleAvatar(
                  radius: 12,
                  backgroundColor: Colors.teal,
                  child: Text(
                    message['unread']!,
                    style: TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }
}

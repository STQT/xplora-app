import 'package:flutter/material.dart';
import 'package:discoveria/screens/message/request_screen.dart';

class RequestsListScreen extends StatelessWidget {
  final List<Map<String, String>> requests = [
    {
      "name": "Alex Linderson",
      "message": "Requests to join your LA party on 09.10.2024",
      "time": "3 hours ago",
    },
    // Добавьте другие запросы
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: requests.length,
      itemBuilder: (context, index) {
        final request = requests[index];
        return ListTile(
          leading: CircleAvatar(
            backgroundImage: NetworkImage(
                'https://picsum.photos/150?random=1'), // Замените на реальную картинку
          ),
          title: Text(
            request['name']!,
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(request['message']!),
          trailing: Icon(Icons.remove_red_eye, color: Color(0xFF77C2C8)),
          onTap: () {
            // Переход на экран запроса
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => RequestScreen(
                  userName: request['name']!,
                  userImage: 'https://picsum.photos/150?random=1',
                  requestMessage:
                  "Hi! I’m Alex, a software engineer from the Netherlands. "
                      "I’m heading to LA and would love to meet some locals and fellow tourists, "
                      "so I’d be excited to attend your party. Please let me know if you would like "
                      "some other info from me!\n\n"
                      "My instagram is @alexlind and my linkedin is Alex Linderson.",
                  requestTime: request['time']!,
                ),
              ),
            );
          },
        );
      },
    );
  }
}

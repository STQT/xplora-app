import 'package:flutter/material.dart';

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
          trailing: Icon(Icons.remove_red_eye, color: Colors.teal),
        );
      },
    );
  }
}

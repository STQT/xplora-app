import 'package:flutter/material.dart';

class MatchScreenEvents extends StatelessWidget {
  final List<Map<String, String>> events = [
    {
      "title": "Party in LA",
      "date": "09.10.2024",
      "attendees": "50",
      "image": "https://via.placeholder.com/300.png?text=Party+in+LA",
    },
    {
      "title": "Tech Conference",
      "date": "12.11.2024",
      "attendees": "200",
      "image": "https://via.placeholder.com/300.png?text=Tech+Conference",
    },
    // Добавьте больше событий
  ];

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.all(16),
      itemCount: events.length,
      itemBuilder: (context, index) {
        final event = events[index];
        return Card(
          margin: EdgeInsets.only(bottom: 16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          clipBehavior: Clip.antiAlias,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Image.network(
                event['image']!,
                height: 180,
                width: double.infinity,
                fit: BoxFit.cover,
              ),
              Padding(
                padding: EdgeInsets.all(16),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      event['title']!,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(height: 4),
                    Text("Date: ${event['date']}"),
                    SizedBox(height: 4),
                    Text("Attendees: ${event['attendees']}"),
                  ],
                ),
              ),
              Row(
                children: [
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        // Запрос на присоединение к мероприятию
                      },
                      child: Text("Request to join"),
                    ),
                  ),
                  Expanded(
                    child: TextButton(
                      onPressed: () {
                        // Логика для редактирования мероприятий
                      },
                      child: Text("Edit your events"),
                    ),
                  ),
                ],
              )
            ],
          ),
        );
      },
    );
  }
}

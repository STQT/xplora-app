import 'package:flutter/material.dart';
import 'match_screen_people.dart';
import 'match_screen_events.dart';

class MatchScreen extends StatefulWidget {
  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Discoveria"),
        backgroundColor: Colors.teal,
        automaticallyImplyLeading: false, // Убирает кнопку "Назад"
        bottom: TabBar(
          controller: _tabController,
          indicatorColor: Colors.white,
          tabs: [
            Tab(text: "People"),
            Tab(text: "Events"),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          MatchScreenPeople(), // Вкладка для людей
          MatchScreenEvents(), // Вкладка для мероприятий
        ],
      ),
    );
  }
}

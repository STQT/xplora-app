import 'package:flutter/material.dart';
import 'match_screen_people.dart';
import 'events/match_screen_events.dart';

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
        title: Text(
          "Discoveria",
          style: TextStyle(
            color: Colors.teal,
            fontFamily: 'Fira Sans Condensed',
            fontWeight: FontWeight.bold,
          ),
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(48.0),
          child: TabBar(
            controller: _tabController,
            indicatorColor: Colors.teal,
            labelStyle: TextStyle(
              fontFamily: 'Fira Sans Condensed',
              fontWeight: FontWeight.w600,
              fontSize: 16,
            ),
            labelColor: Colors.teal,
            unselectedLabelColor: Colors.black54,
            tabs: [
              Tab(text: "People"),
              Tab(text: "Events"),
            ],
          ),
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(), // Отключаем свайп между вкладками
        children: [
          MatchScreenPeople(), // Tab for "People"
          MatchScreenEvents(), // Tab for "Events"
        ],
      ),
      // Insert the Bottom Navigation Bar here
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: 1, // Active tab is Match
        onTap: (index) {
          if (index == 0) {
            Navigator.pushNamed(context, '/message'); // Go to Message screen
          } else if (index == 2) {
            Navigator.pushNamed(context, '/profile'); // Go to Profile screen
          }
        },
        items: [
          BottomNavigationBarItem(
            icon: Icon(Icons.message),
            label: "Message",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.group),
            label: "Match",
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.person),
            label: "Profile",
          ),
        ],
      ),
    );
  }
}

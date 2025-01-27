import 'package:flutter/material.dart';
import 'match_screen_people.dart';
import 'events/match_screen_events.dart';
import 'package:discoveria/components/bottom_nav_bar.dart';

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
    return ScaffoldWithAnimation(
      child: Scaffold(
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
          physics: NeverScrollableScrollPhysics(),
          // Отключаем свайп между вкладками
          children: [
            MatchScreenPeople(), // Tab for "People"
            MatchScreenEvents(), // Tab for "Events"
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(currentIndex: 1),
      ),
    );
  }
}

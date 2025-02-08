import 'package:flutter/material.dart';
import 'match_screen_people.dart';
import 'events/match_screen_events.dart';
import 'package:discoveria/components/bottom_nav_bar.dart';

class MatchScreen extends StatefulWidget {
  final int initialTabIndex;

  MatchScreen({this.initialTabIndex = 0}); // По умолчанию открывается вкладка "People"

  @override
  _MatchScreenState createState() => _MatchScreenState();
}

class _MatchScreenState extends State<MatchScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
      initialIndex: widget.initialTabIndex, // Устанавливаем вкладку при загрузке
    );
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
              color: Color(0xFF77C2C8),
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
              indicatorColor: Color(0xFF77C2C8),
              labelStyle: TextStyle(
                fontFamily: 'Fira Sans Condensed',
                fontWeight: FontWeight.w600,
                fontSize: 16,
              ),
              labelColor: Color(0xFF77C2C8),
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
          physics: NeverScrollableScrollPhysics(), // Отключаем свайп
          children: [
            MatchScreenPeople(), // Вкладка "People"
            MatchScreenEvents(), // Вкладка "Events"
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(currentIndex: 1),
      ),
    );
  }
}

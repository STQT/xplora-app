import 'package:flutter/material.dart';
import 'messages_list.dart';
import 'requests_list.dart';
import 'package:discoveria/components/bottom_nav_bar.dart';

class MessagesScreen extends StatefulWidget {
  @override
  _MessagesScreenState createState() => _MessagesScreenState();
}

class _MessagesScreenState extends State<MessagesScreen>
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
          automaticallyImplyLeading: true,
          bottom: TabBar(
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
              Tab(text: "Messages"),
              Tab(text: "Requests"),
            ],
          ),
        ),
        body: TabBarView(
          controller: _tabController,
          children: [
            MessagesListScreen(), // Экран для сообщений
            RequestsListScreen(), // Экран для запросов
          ],
        ),
        bottomNavigationBar: CustomBottomNavBar(currentIndex: 0),
      ),
    );
  }
}

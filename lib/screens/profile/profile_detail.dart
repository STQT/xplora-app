import 'package:flutter/material.dart';
import 'package:discoveria/components/bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAnimation(
      child: Scaffold(
        appBar: AppBar(
          title: Text("Profile"),
          backgroundColor: Colors.transparent,
          elevation: 0,
        ),
        body: Center(child: Text("Profile Content Here")),
        bottomNavigationBar: CustomBottomNavBar(currentIndex: 2),
      ),
    );
  }
}

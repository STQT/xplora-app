import 'package:flutter/material.dart';
import 'package:animations/animations.dart';
import 'package:discoveria/screens/match_screen.dart';
import 'package:discoveria/screens/message/messages_screen.dart';
import 'package:discoveria/screens/profile/profile_detail.dart';

class CustomBottomNavBar extends StatelessWidget {
  final int currentIndex;

  const CustomBottomNavBar({Key? key, required this.currentIndex})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      onTap: (index) {
        if (index == currentIndex) return;

        final screens = [
          MessagesScreen(),
          MatchScreen(),
          ProfileScreen(),
        ];

        Navigator.pushReplacement(
          context,
          PageRouteBuilder(
            pageBuilder: (_, __, ___) => ScaffoldWithAnimation(
              child: screens[index],
            ),
            transitionsBuilder: (_, animation, secondaryAnimation, child) {
              return SharedAxisTransition(
                animation: animation,
                secondaryAnimation: secondaryAnimation,
                transitionType: index > currentIndex
                    ? SharedAxisTransitionType.horizontal
                    : SharedAxisTransitionType.horizontal,
                child: child,
              );
            },
          ),
        );
      },
      items: [
        BottomNavigationBarItem(
          icon: Icon(
            currentIndex == 0 ? Icons.message_rounded : Icons.message_outlined,
          ),
          label: "Message",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            currentIndex == 1 ? Icons.group : Icons.group_outlined,
          ),
          label: "Match",
        ),
        BottomNavigationBarItem(
          icon: Icon(
            currentIndex == 2 ? Icons.person : Icons.person_outline,
          ),
          label: "Profile",
        ),
      ],
      selectedItemColor: Color(0xFF77C2C8),
      unselectedItemColor: Colors.grey,
    );
  }
}

class ScaffoldWithAnimation extends StatelessWidget {
  final Widget child;

  const ScaffoldWithAnimation({Key? key, required this.child}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return PageTransitionSwitcher(
      duration: Duration(milliseconds: 300),
      transitionBuilder: (child, animation, secondaryAnimation) {
        return SharedAxisTransition(
          animation: animation,
          secondaryAnimation: secondaryAnimation,
          transitionType: SharedAxisTransitionType.horizontal,
          child: child,
        );
      },
      child: child,
    );
  }
}

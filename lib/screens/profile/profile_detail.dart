import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:discoveria/components/bottom_nav_bar.dart';

class ProfileScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return ScaffoldWithAnimation(
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size.fromHeight(10), // Высота AppBar 10px
          child: AppBar(
            automaticallyImplyLeading: false,
            backgroundColor: Colors.transparent,
            elevation: 0,
          ),
        ),
        body: SingleChildScrollView(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Profile Image
              CircleAvatar(
                radius: 50,
                backgroundImage: NetworkImage(
                  'https://picsum.photos/200?random=1', // Реальная картинка пользователя
                ),
              ),
              SizedBox(height: 10),
              // Name & Username
              Text(
                "Alex Linderson",
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Fira Sans Condensed',
                ),
              ),
              Text(
                "@alexlind",
                style: TextStyle(
                  fontSize: 14,
                  color: Color(0xFF77C2C8),
                  fontFamily: 'Fira Sans Condensed',
                ),
              ),
              SizedBox(height: 20),

              // Interests
              _buildSection("Interests", ["Yoga", "Shopping", "Hiking"]),
              _buildSection("Languages", ["English", "French"]),
              _buildBioSection(),

              SizedBox(height: 20),
            ],
          ),
        ),
        bottomNavigationBar:
            CustomBottomNavBar(currentIndex: 2), // Активный таб — "Profile"
      ),
    );
  }

  // Виджет для разделов "Interests" и "Languages"
  Widget _buildSection(String title, List<String> items) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                title,
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Fira Sans Condensed',
                ),
              ),
              SizedBox(width: 6),
              SvgPicture.asset(
                "assets/icons/edit.svg",
                width: 18,
                height: 18,
                color: Color(0xFF77C2C8),
              ),
            ],
          ),
          SizedBox(height: 4),
          ...items.map((item) => Text(
                "• $item",
                style:
                    TextStyle(fontSize: 14, fontFamily: 'Fira Sans Condensed'),
              )),
          Divider(),
        ],
      ),
    );
  }

  // Виджет для раздела "Bio"
  Widget _buildBioSection() {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(
                "Bio",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Fira Sans Condensed',
                ),
              ),
              SizedBox(width: 6),
              SvgPicture.asset(
                "assets/icons/edit.svg",
                width: 18,
                height: 18,
                color: Color(0xFF77C2C8),
              ),
            ],
          ),
          SizedBox(height: 4),
          Text(
            "Hi! I’m Alex, a software engineer from the Netherlands. "
            "I’m heading to LA and would love to meet some locals and fellow tourists. "
            "\n\nMy instagram is @alexlind and my linkedin is Alex Linderson.",
            style: TextStyle(fontSize: 14, fontFamily: 'Fira Sans Condensed'),
          ),
          Divider(),
        ],
      ),
    );
  }
}

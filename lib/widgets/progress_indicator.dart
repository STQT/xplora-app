import 'package:flutter/material.dart';

class ProfileProgressIndicator extends StatelessWidget {
  final int step;

  const ProfileProgressIndicator({required this.step});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        3,
            (index) => Container(
          margin: EdgeInsets.symmetric(horizontal: 4),
          width: 12,
          height: 12,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: index < step ? Color(0xFF4CAF93) : Colors.grey.shade300,
          ),
        ),
      ),
    );
  }
}

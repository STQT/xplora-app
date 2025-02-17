import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class DiscoveriaLogo extends StatelessWidget {
  final double iconSize;
  final double spacing;
  final Color textColor;
  final double fontSize;

  const DiscoveriaLogo({
    Key? key,
    this.iconSize = 24.0,
    this.spacing = 4.0,
    this.textColor = const Color(0xFF121414),
    this.fontSize = 16.0,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          width: iconSize,
          height: iconSize,
          child: SvgPicture.asset("assets/icons/logo.svg"),
        ),
        SizedBox(width: spacing), // Отступ между иконкой и текстом
        Text(
          "Xplora",
          style: TextStyle(
            fontFamily: 'Fira Sans Condensed',
            fontSize: fontSize,
            color: textColor,
          ),
        ),
      ],
    );
  }
}

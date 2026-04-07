import 'package:flutter/material.dart';

class Button extends StatelessWidget {
  const Button({super.key, required this.text, required this.onClick});

  final String text;
  final void Function() onClick;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          color: Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 32.0, vertical: 16.0),
          child: Text(
            text,
            style: TextStyle(
              color: Colors.white,
              fontSize: 24.0,
              fontFamily: 'Doto',
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }
}

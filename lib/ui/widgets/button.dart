import 'package:flutter/material.dart';

class MenuButton extends StatelessWidget {
  const MenuButton({super.key, required this.child, required this.onClick});

  MenuButton.text({super.key, required String text, required this.onClick})
    : child = Padding(
        padding: EdgeInsets.symmetric(horizontal: 16.0),
        child: Text(
          text,
          style: TextStyle(
            color: Colors.white,
            fontSize: 24.0,
            fontFamily: 'Doto',
            fontWeight: FontWeight.w600,
          ),
        ),
      );

  final Widget child;
  final void Function() onClick;

  @override
  Widget build(BuildContext context) {
    return MouseRegion(
      cursor: SystemMouseCursors.click,
      child: GestureDetector(
        onTap: onClick,
        child: Container(
          color: Colors.black,
          padding: EdgeInsets.symmetric(horizontal: 16.0, vertical: 16.0),
          child: child,
        ),
      ),
    );
  }
}

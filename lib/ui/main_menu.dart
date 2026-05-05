import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:space_game/ui/widgets/button.dart';

class MainMenu extends StatelessWidget {
  const MainMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Space Game',
          style: TextStyle(
            color: Colors.white,
            fontSize: 64.0,
            fontFamily: 'Doto',
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 128.0),
        Column(
          mainAxisSize: MainAxisSize.min,
          spacing: 16.0,
          children: [
            Button(text: 'New Game', onClick: () => context.go('/game')),
            Button(text: 'Load Game', onClick: () => context.push('/load')),
            Button(text: 'Settings', onClick: () => context.push('/settings')),
            Button(text: 'Exit', onClick: () => SystemNavigator.pop()),
          ],
        ),
      ],
    );
  }
}

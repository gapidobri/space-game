import 'package:flutter/material.dart';
import 'package:space_game/game/app/game.dart';

class SpaceGameApp extends StatelessWidget {
  const SpaceGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(home: SpaceGame());
  }
}

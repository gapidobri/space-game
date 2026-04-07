import 'package:flutter/material.dart';
import 'package:space_game/routes.dart';

class SpaceGameApp extends StatelessWidget {
  const SpaceGameApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp.router(
      builder: (context, child) => Material(color: Colors.black, child: child),
      theme: ThemeData(fontFamily: 'Doto'),
      routerConfig: routerConfig,
    );
  }
}

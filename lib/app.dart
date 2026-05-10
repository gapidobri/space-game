import 'package:flutter/material.dart';
import 'package:space_game/routes.dart';
import 'package:space_game/settings.dart';

class SpaceGameApp extends StatelessWidget {
  const SpaceGameApp({super.key, required this.settings});

  final SettingsController settings;

  @override
  Widget build(BuildContext context) {
    return SettingsScope(
      controller: settings,
      child: MaterialApp.router(
        builder: (context, child) =>
            Material(color: Colors.black, child: child),
        theme: ThemeData(fontFamily: 'Doto'),
        routerConfig: routerConfig,
      ),
    );
  }
}

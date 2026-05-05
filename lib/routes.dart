import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:space_game/game/app/game.dart';
import 'package:space_game/ui/load_menu.dart';
import 'package:space_game/ui/main_menu.dart';
import 'package:space_game/ui/settings/settings_menu.dart';

final routerConfig = GoRouter(
  routes: [
    ShellRoute(
      pageBuilder: (context, state, child) => NoTransitionPage(
        child: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/main_menu.png'),
              fit: BoxFit.cover,
            ),
          ),
          child: child,
        ),
      ),
      routes: [
        GoRoute(
          path: '/',
          pageBuilder: (_, _) => NoTransitionPage(child: MainMenu()),
        ),
        GoRoute(
          path: '/settings',
          pageBuilder: (_, _) => NoTransitionPage(child: SettingsMenu()),
        ),
        GoRoute(
          path: '/load',
          pageBuilder: (_, _) => NoTransitionPage(child: LoadMenu()),
        ),
      ],
    ),
    GoRoute(
      path: '/game',
      pageBuilder: (_, state) =>
          NoTransitionPage(child: SpaceGame(saveFile: state.extra as String?)),
    ),
  ],
);

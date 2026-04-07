import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:space_game/ui/widgets/button.dart';

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          'Settings',
          style: TextStyle(
            color: Colors.white,
            fontSize: 64.0,
            fontFamily: 'Doto',
            fontWeight: FontWeight.w700,
          ),
        ),
        SizedBox(height: 128.0),
        // TODO: music volume, sfx volume
        Button(text: 'Back', onClick: () => context.go('/')),
      ],
    );
  }
}

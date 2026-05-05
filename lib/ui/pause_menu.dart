import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:space_game/ui/widgets/button.dart';

class PauseMenu extends StatelessWidget {
  const PauseMenu({super.key, required this.onResume, required this.onSave});

  final void Function() onResume;
  final void Function() onSave;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              'Paused',
              style: TextStyle(
                color: Colors.white,
                fontSize: 64.0,
                fontFamily: 'Doto',
                fontWeight: FontWeight.w700,
              ),
            ),
            SizedBox(height: 64.0),
            Column(
              mainAxisSize: MainAxisSize.min,
              spacing: 16.0,
              children: [
                Button(text: 'Resume', onClick: onResume),
                Button(
                  text: 'Settings',
                  onClick: () => context.push('/settings'),
                ),
                Button(text: 'Save', onClick: onSave),
                Button(text: 'Leave', onClick: () => context.go('/')),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

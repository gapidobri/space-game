import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:space_game/ui/settings/settings_menu.dart';
import 'package:space_game/ui/widgets/button.dart';

class PauseMenu extends StatefulWidget {
  const PauseMenu({super.key, required this.onResume, required this.onSave});

  final void Function() onResume;
  final void Function() onSave;

  @override
  State<PauseMenu> createState() => _PauseMenuState();
}

class _PauseMenuState extends State<PauseMenu> {
  bool _showSettings = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.black.withValues(alpha: 0.5),
      child: Center(
        child: _showSettings
            ? SettingsMenu(onBack: () => setState(() => _showSettings = false))
            : Column(
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
                      Button(text: 'Resume', onClick: widget.onResume),
                      Button(
                        text: 'Settings',
                        onClick: () => setState(() => _showSettings = true),
                      ),
                      Button(text: 'Save', onClick: widget.onSave),
                      Button(text: 'Leave', onClick: () => context.go('/')),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

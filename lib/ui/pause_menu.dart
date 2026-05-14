import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:space_game/ui/settings/settings_menu.dart';
import 'package:space_game/ui/widgets/button.dart';
import 'package:space_game/ui/widgets/save_dialog.dart';

class PauseMenu extends StatefulWidget {
  const PauseMenu({super.key, required this.onResume, required this.onSave});

  final void Function() onResume;
  final void Function(String) onSave;

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
                      MenuButton.text(text: 'Resume', onClick: widget.onResume),
                      MenuButton.text(
                        text: 'Settings',
                        onClick: () => setState(() => _showSettings = true),
                      ),
                      MenuButton.text(
                        text: 'Save',
                        onClick: () async {
                          final result = await showDialog<String?>(
                            context: context,
                            builder: (context) => SaveDialog(),
                          );
                          if (result == null) return;

                          widget.onSave(result);
                        },
                      ),
                      MenuButton.text(
                        text: 'Leave',
                        onClick: () => context.go('/'),
                      ),
                    ],
                  ),
                ],
              ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:space_game/settings.dart';
import 'package:space_game/ui/widgets/button.dart';

class SettingsMenu extends StatelessWidget {
  const SettingsMenu({super.key, this.onBack});

  final VoidCallback? onBack;

  @override
  Widget build(BuildContext context) {
    final controller = SettingsScope.of(context);
    final onBack = this.onBack ?? () => context.pop();

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

        ValueListenableBuilder(
          valueListenable: controller,
          builder: (context, state, _) {
            return SizedBox(
              width: 200,
              child: Slider(
                value: state.musicVolume,
                onChanged: (value) =>
                    controller.setMusicVolume(value, persist: false),
                onChangeEnd: (value) =>
                    controller.setMusicVolume(value, persist: true),
              ),
            );
          },
        ),

        Button(text: 'Back', onClick: onBack),
      ],
    );
  }
}

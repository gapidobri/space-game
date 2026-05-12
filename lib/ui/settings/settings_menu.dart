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
            return Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  'Music volume',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontFamily: 'Doto',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Slider(
                    value: state.musicVolume,
                    onChanged: (value) =>
                        controller.setMusicVolume(value, persist: false),
                    onChangeEnd: (value) =>
                        controller.setMusicVolume(value, persist: true),
                  ),
                ),
                SizedBox(height: 48.0),

                Button(
                  text: 'SFX: ${state.sfxEnabled ? 'On' : 'Off'}',
                  onClick: () => controller.setSfxEnabled(!state.sfxEnabled),
                ),
                SizedBox(height: 16.0),

                Text(
                  'SFX volume',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontFamily: 'Doto',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                SizedBox(
                  width: 200,
                  child: Slider(
                    value: state.sfxVolume,
                    onChanged: state.sfxEnabled
                        ? (value) =>
                              controller.setSfxVolume(value, persist: false)
                        : null,
                    onChangeEnd: state.sfxEnabled
                        ? (value) =>
                              controller.setSfxVolume(value, persist: true)
                        : null,
                  ),
                ),
              ],
            );
          },
        ),

        Button(text: 'Back', onClick: onBack),
      ],
    );
  }
}

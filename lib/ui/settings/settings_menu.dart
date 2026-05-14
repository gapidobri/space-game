import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:space_game/settings.dart';
import 'package:space_game/ui/widgets/button.dart';
import 'package:space_game/ui/widgets/slider.dart';

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
                const SizedBox(height: 16.0),
                Row(
                  mainAxisSize: .min,
                  children: [
                    MenuButton(
                      child: state.musicEnabled
                          ? Image.asset('assets/icons/sound_on.png')
                          : Image.asset('assets/icons/sound_off.png'),
                      onClick: () =>
                          controller.setMusicEnabled(!state.musicEnabled),
                    ),

                    const SizedBox(width: 16.0),

                    SizedBox(
                      width: 200,
                      child: MenuSlider(
                        value: state.musicEnabled ? state.musicVolume : 0.0,
                        onChanged: (value) {
                          controller.setMusicEnabled(true, persist: false);
                          controller.setMusicVolume(value, persist: false);
                        },
                        onChangeEnd: (value) {
                          controller.setMusicEnabled(true, persist: true);
                          controller.setMusicVolume(value, persist: true);
                        },
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 48.0),

                Text(
                  'SFX volume',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 24.0,
                    fontFamily: 'Doto',
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(height: 16.0),
                Row(
                  mainAxisSize: .min,
                  children: [
                    MenuButton(
                      child: state.sfxEnabled
                          ? Image.asset('assets/icons/sound_on.png')
                          : Image.asset('assets/icons/sound_off.png'),
                      onClick: () =>
                          controller.setSfxEnabled(!state.sfxEnabled),
                    ),

                    const SizedBox(width: 16.0),

                    SizedBox(
                      width: 200,
                      child: MenuSlider(
                        value: state.sfxEnabled ? state.sfxVolume : 0.0,
                        onChanged: (value) {
                          controller.setSfxEnabled(true, persist: false);
                          controller.setSfxVolume(value, persist: false);
                        },
                        onChangeEnd: (value) {
                          controller.setSfxEnabled(true, persist: true);
                          controller.setSfxVolume(value, persist: true);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            );
          },
        ),

        SizedBox(height: 48.0),

        MenuButton.text(text: 'Back', onClick: onBack),
      ],
    );
  }
}

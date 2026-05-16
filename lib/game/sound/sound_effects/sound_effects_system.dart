import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/projectile/projectile_tag.dart';
import 'package:space_game/game/rocket/components/rocket_propulsion_state.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';
import 'package:space_game/game/settings/audio_settings.dart';

class SoundEffectsSystem extends System {
  SoundEffectsSystem({super.priority, required this.eventBus});

  final _instance = SoLoud.instance;

  final EventBus eventBus;

  SoundHandle? _rocketEngineSoundHandle;
  SoundHandle? _bulletHitSoundHandle;

  @override
  void update(double dt, World world, Commands commands) async {
    final audioSettings = world.tryGetComponent<AudioSettings>();
    final volume = audioSettings?.sfxVolume ?? 0.5;

    if (_rocketEngineSoundHandle == null) {
      final source = await _instance.loadAsset(
        'assets/sfx/rocket_engine_loop.wav',
      );
      _rocketEngineSoundHandle = _instance.play(
        source,
        looping: true,
        paused: true,
        volume: volume,
      );
    }

    if (_bulletHitSoundHandle == null) {
      final source = await _instance.loadAsset('assets/sfx/hit.wav');
      _bulletHitSoundHandle = _instance.play(
        source,
        looping: false,
        paused: true,
      );
    }

    if (_rocketEngineSoundHandle != null) {
      _instance.setVolume(_rocketEngineSoundHandle!, volume);
      final rocket = world.query<RocketTag>().firstOrNull;
      if (rocket != null) {
        final propulsion = rocket.get<RocketPropulsionState>();
        _instance.setPause(_rocketEngineSoundHandle!, !propulsion.thrusting);
        _instance.setRelativePlaySpeed(
          _rocketEngineSoundHandle!,
          propulsion.boosting ? 1.5 : 1.0,
        );
      } else {
        _instance.setVolume(_rocketEngineSoundHandle!, 0);
      }
    }

    if (_bulletHitSoundHandle != null) {
      _instance.setVolume(_bulletHitSoundHandle!, volume);
    }

    for (final event in eventBus.read<CollisionEvent>()) {
      if (!event.entities.any((e) => e.has<ProjectileTag>())) continue;

      if (_bulletHitSoundHandle != null) {
        _instance.seek(_bulletHitSoundHandle!, Duration.zero);
        _instance.setPause(_bulletHitSoundHandle!, false);
      }
    }
  }
}

import 'dart:async';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/events/alien_destroyed_event.dart';
import 'package:space_game/game/planet/planet_tag.dart';
import 'package:space_game/game/rocket/components/fuel_tank.dart';
import 'package:space_game/game/rocket/components/rocket_engine.dart';
import 'package:space_game/game/rocket/components/rocket_propulsion_state.dart';
import 'package:space_game/game/rocket/events/rocket_destroyed_event.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';
import 'package:space_game/game/settings/audio_settings.dart';
import 'package:space_game/game/shared/damage/events/damage_applied_event.dart';

class SoundEffectsSystem extends System {
  SoundEffectsSystem({
    super.priority,
    required this.eventBus,
    AudioEngine? audio,
  }) : _audio = audio ?? AudioEngine();

  final EventBus eventBus;
  final AudioEngine _audio;

  static const _engineLoopChannel = 'sfx.loop.rocketEngine';

  static const _rocketEngineLoopAsset = 'assets/sfx/rocket_engine_loop.mp3';
  static const _rocketImpactAsset = 'assets/sfx/rocket_impact.mp3';
  static const _rocketExplosionAsset = 'assets/sfx/rocket_explosion.mp3';
  static const _alienExplosionAsset = 'assets/sfx/alien_explosion.mp3';

  final List<String> _oneShotChannels = List<String>.generate(
    8,
    (i) => 'sfx.$i',
    growable: false,
  );

  final Set<String> _disabledAssets = <String>{};

  bool _engineLoopPlaying = false;
  double _engineLoopVolume = 1.0;

  int _nextOneShot = 0;

  Future<void> _engineLoopQueue = Future<void>.value();

  @override
  bool get runWhenPaused => true;

  @override
  void update(double dt, World world, Commands commands) {
    final settings = world.tryGetComponent<AudioSettings>();
    final sfxEnabled = settings?.sfxEnabled ?? true;
    final sfxVolume = (settings?.sfxVolume ?? 1.0).clamp(0.0, 1.0);

    if (dt <= 0 || !sfxEnabled || sfxVolume <= 0) {
      _stopAll();
      return;
    }

    _updateRocketEngineLoop(world: world, volume: sfxVolume);

    for (final event in eventBus.read<DamageAppliedEvent>()) {
      if (event.target.has<RocketTag>() && event.source.has<PlanetTag>()) {
        _playOneShot(_rocketImpactAsset, volume: sfxVolume);
      }
    }

    if (eventBus.read<RocketDestroyedEvent>().isNotEmpty) {
      _playOneShot(_rocketExplosionAsset, volume: sfxVolume);
    }

    for (final _ in eventBus.read<AlienDestroyedEvent>()) {
      _playOneShot(_alienExplosionAsset, volume: sfxVolume);
    }
  }

  void _updateRocketEngineLoop({required World world, required double volume}) {
    final rocket = world.query<RocketTag>().firstOrNull;
    final propulsion = rocket?.tryGet<RocketPropulsionState>();
    final engine = rocket?.tryGet<RocketEngine>();
    final fuelTank = rocket?.tryGet<FuelTank>();

    final shouldPlay =
        (propulsion?.thrusting ?? false) &&
        (engine?.enabled ?? false) &&
        (fuelTank?.fuel ?? 0) > 0;

    if (!shouldPlay) {
      if (_engineLoopPlaying) {
        _engineLoopPlaying = false;
        _enqueueEngineLoop(() => _safeStop(_engineLoopChannel));
      }
      return;
    }

    if (!_engineLoopPlaying) {
      _engineLoopPlaying = true;
      _engineLoopVolume = volume;
      _enqueueEngineLoop(
        () => _safePlay(
          channel: _engineLoopChannel,
          assetPath: _rocketEngineLoopAsset,
          loop: true,
          volume: _engineLoopVolume,
          restart: true,
        ),
      );
      return;
    }

    if (volume != _engineLoopVolume) {
      _engineLoopVolume = volume;
      _enqueueEngineLoop(
        () => _safeSetVolume(_engineLoopChannel, _engineLoopVolume),
      );
    }
  }

  void _enqueueEngineLoop(Future<void> Function() op) {
    _engineLoopQueue = _engineLoopQueue.then((_) => op());
  }

  void _playOneShot(String assetPath, {required double volume}) {
    final channel = _oneShotChannels[_nextOneShot];
    _nextOneShot = (_nextOneShot + 1) % _oneShotChannels.length;

    unawaited(
      _safePlay(
        channel: channel,
        assetPath: assetPath,
        loop: false,
        volume: volume,
        restart: true,
      ),
    );
  }

  void _stopAll() {
    if (_engineLoopPlaying) {
      _engineLoopPlaying = false;
      _enqueueEngineLoop(() => _safeStop(_engineLoopChannel));
    }

    for (final channel in _oneShotChannels) {
      unawaited(_safeStop(channel));
    }
  }

  Future<void> _safePlay({
    required String channel,
    required String assetPath,
    required bool loop,
    required double volume,
    required bool restart,
  }) async {
    if (_disabledAssets.contains(assetPath)) return;

    try {
      await _audio.play(
        channel: channel,
        assetPath: assetPath,
        loop: loop,
        volume: volume,
        restart: restart,
      );
    } catch (_) {
      _disabledAssets.add(assetPath);
    }
  }

  Future<void> _safeSetVolume(String channel, double volume) async {
    try {
      await _audio.setVolume(channel, volume);
    } catch (_) {}
  }

  Future<void> _safeStop(String channel) async {
    try {
      await _audio.stop(channel);
    } catch (_) {}
  }

  @override
  void dispose() {
    unawaited(_audio.dispose());
  }
}

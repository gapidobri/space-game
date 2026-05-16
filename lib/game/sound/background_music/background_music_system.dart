import 'dart:math';

import 'package:flutter_soloud/flutter_soloud.dart';
import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/settings/audio_settings.dart';
import 'package:space_game/game/sound/background_music/background_music.dart';

class BackgroundMusicSystem extends System {
  final _initing = <Entity>{};
  final _sources = <Entity, AudioSource>{};
  final _players = <Entity, SoundHandle>{};

  final _instance = SoLoud.instance;

  @override
  bool get runWhenPaused => true;

  @override
  void update(double dt, World world, Commands commands) async {
    final settings = world.tryGetComponent<AudioSettings>();
    final musicVolume = settings?.musicVolume ?? 1;

    for (final entity in world.query<BackgroundMusic>()) {
      final music = entity.get<BackgroundMusic>();
      var player = _players[entity];

      if (_initing.contains(entity)) continue;
      if (player == null) {
        _initing.add(entity);
        final sound = await _instance.loadAsset(music.assetPath);
        player = _instance.play(sound, looping: false, volume: 0);
        _players[entity] = player;
        _sources[entity] = sound;
        _initing.remove(entity);
      }

      if (music.playing) {
        _instance.setPause(player, false);
        if (music.fadeProgress < 1) {
          music.fadeProgress += dt / music.fadeTime;
          music.fadeProgress = min(music.fadeProgress, 1);
        }
      } else {
        if (music.fadeProgress > 0) {
          music.fadeProgress -= dt / music.fadeTime;
          music.fadeProgress = max(music.fadeProgress, 0);
        } else {
          _instance.setPause(player, true);
        }
      }

      _instance.setVolume(player, musicVolume * music.fadeProgress);
    }

    final toRemove = <Entity>[];
    for (final MapEntry(key: entity, value: player) in _players.entries) {
      if (world.entities.contains(entity)) continue;

      final music = entity.tryGet<BackgroundMusic>();
      if (music != null) {
        music.playing = false;
        if (music.fadeProgress > 0) {
          music.fadeProgress -= dt / music.fadeTime;
          music.fadeProgress = max(music.fadeProgress, 0);
          _instance.setVolume(player, musicVolume * music.fadeProgress);
          continue;
        }
      }

      final source = _sources[entity];
      if (source != null) {
        _instance.disposeSource(source);
      }
      toRemove.add(entity);
    }
    _players.removeWhere((e, p) => toRemove.contains(e));
    _sources.removeWhere((e, p) => toRemove.contains(e));
  }

  @override
  void dispose() {
    for (final source in _sources.values) {
      _instance.disposeSource(source);
    }
  }
}

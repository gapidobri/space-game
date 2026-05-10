import 'dart:math';

import 'package:gamengine/gamengine.dart';
import 'package:just_audio/just_audio.dart';
import 'package:space_game/game/settings/audio_settings.dart';
import 'package:space_game/game/sound/background_music/background_music.dart';

class BackgroundMusicSystem extends System {
  final _players = <Entity, AudioPlayer>{};

  @override
  bool get runWhenPaused => true;

  @override
  void update(double dt, World world, Commands commands) async {
    final settings = world.tryGetComponent<AudioSettings>();
    final musicVolume = settings?.musicVolume ?? 1;

    for (final entity in world.query<BackgroundMusic>()) {
      final music = entity.get<BackgroundMusic>();
      final player = _players.putIfAbsent(
        entity,
        () => AudioPlayer()
          ..setAudioSource(AudioSource.asset(music.assetPath))
          ..setLoopMode(.one)
          ..setVolume(0),
      );
      if (music.playing) {
        player.play();
        if (music.fadeProgress < 1) {
          music.fadeProgress += dt / music.fadeTime;
          music.fadeProgress = min(music.fadeProgress, 1);
        }
      } else {
        if (music.fadeProgress > 0) {
          music.fadeProgress -= dt / music.fadeTime;
          music.fadeProgress = max(music.fadeProgress, 0);
        } else {
          player.pause();
        }
      }

      player.setVolume(musicVolume * music.fadeProgress);
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
          player.setVolume(musicVolume * music.fadeProgress);
          continue;
        }
      }

      player.dispose();
      toRemove.add(entity);
    }
    _players.removeWhere((e, p) => toRemove.contains(e));
  }

  @override
  void dispose() {
    for (final player in _players.values) {
      player.dispose();
    }
  }
}

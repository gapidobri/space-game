import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/settings/audio_settings.dart';

Entity createSettings() {
  final entity = Entity();

  entity.add(AudioSettings(musicVolume: 0.25));

  return entity;
}

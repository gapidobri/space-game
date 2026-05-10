import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/planet/planet_spawn_spec.dart';

class AstronautSpawnSpec {
  const AstronautSpawnSpec({
    required this.astronautImage,
    required this.shipWreckImage,
    required this.planet,
    required this.planetAngle,
  });

  final Asset<Image> astronautImage;
  final Asset<Image> shipWreckImage;
  final PlanetSpawnSpec planet;
  final double planetAngle;
}

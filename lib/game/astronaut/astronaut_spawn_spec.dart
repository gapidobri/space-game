import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/planet/planet_spawn_spec.dart';

class AstronautSpawnSpec {
  const AstronautSpawnSpec({
    required this.image,
    required this.planet,
    required this.planetAngle,
  });

  final Asset<Image> image;
  final PlanetSpawnSpec planet;
  final double planetAngle;
}

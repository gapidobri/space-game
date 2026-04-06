import 'dart:ui';

import 'package:space_game/game/planet/planet_spawn_spec.dart';

class AstronautSpawnSpec {
  const AstronautSpawnSpec({
    required this.image,
    required this.planet,
    required this.planetAngle,
  });

  final Image image;
  final PlanetSpawnSpec planet;
  final double planetAngle;
}

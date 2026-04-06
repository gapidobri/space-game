import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/planet/atmosphere/atmosphere_config.dart';
import 'package:space_game/game/stage/generation/spawn_footprint.dart';

class PlanetSpawnSpec {
  const PlanetSpawnSpec({
    required this.image,
    required this.position,
    required this.radius,
    required this.mass,
    this.canHostAstronaut = false,
    this.atmosphere,
  });

  final Image image;
  final Vector2 position;
  final double radius;
  final double mass;
  final bool canHostAstronaut;
  final AtmosphereConfig? atmosphere;

  SpawnFootprint get footprint =>
      SpawnFootprint(position: position, radius: radius);
}

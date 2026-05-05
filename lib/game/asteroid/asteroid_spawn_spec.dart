import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/stage/generation/spawn_footprint.dart';

class AsteroidSpawnSpec {
  const AsteroidSpawnSpec({
    required this.position,
    required this.rotation,
    required this.image,
    required this.variant,
  });

  final Vector2 position;
  final double rotation;
  final Asset<Image> image;
  final int variant;

  SpawnFootprint get footprint =>
      SpawnFootprint(position: position, radius: 50);
}

import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/mining/resource_node.dart';
import 'package:space_game/game/planet/planet_spawn_spec.dart';

class MineralSpawnSpec {
  const MineralSpawnSpec({
    required this.mineralImage,
    required this.planet,
    required this.planetAngle,
    required this.resourceType,
    required this.volume,
  });

  final Asset<Image> mineralImage;
  final PlanetSpawnSpec planet;
  final double planetAngle;

  final ResourceType resourceType;
  final double volume;
}

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/stage/generation/spawn_footprint.dart';

class StageSpawnpointSpec {
  const StageSpawnpointSpec({
    required this.position,
    required this.spawnAreaRadius,
  });

  final Vector2 position;
  final double spawnAreaRadius;

  SpawnFootprint get footprint =>
      SpawnFootprint(position: position, radius: spawnAreaRadius);
}

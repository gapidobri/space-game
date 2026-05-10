import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/stage/generation/spawn_footprint.dart';

class ExitPortalSpawnSpec {
  const ExitPortalSpawnSpec({required this.position});

  final Vector2 position;

  SpawnFootprint get footprint =>
      SpawnFootprint(position: position, radius: 500);
}

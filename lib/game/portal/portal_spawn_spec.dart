import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/stage/generation/spawn_footprint.dart';

class PortalSpawnSpec {
  const PortalSpawnSpec({required this.position, required this.parent});

  final Vector2 position;
  final Entity? parent;

  SpawnFootprint get footprint =>
      SpawnFootprint(position: position, radius: 500);
}

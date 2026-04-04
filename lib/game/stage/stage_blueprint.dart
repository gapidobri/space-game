import 'package:space_game/game/asteroid/asteroid_spawn_spec.dart';
import 'package:space_game/game/planet/planet_spawn_spec.dart';
import 'package:space_game/game/portal/portal_spawn_spec.dart';
import 'package:space_game/game/stage/generation/spawn_footprint.dart';

class StageBlueprint {
  StageBlueprint();

  late final SpawnFootprint player;
  late final PortalSpawnSpec portal;
  final List<PlanetSpawnSpec> planets = [];
  final List<AsteroidSpawnSpec> asteroids = [];

  Iterable<SpawnFootprint> get occupied => [player, portal.footprint]
      .followedBy(planets.map((p) => p.footprint))
      .followedBy(asteroids.map((a) => a.footprint));
}

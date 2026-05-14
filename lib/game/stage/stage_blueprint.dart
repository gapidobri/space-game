import 'package:space_game/game/asteroid/asteroid_spawn_spec.dart';
import 'package:space_game/game/astronaut/astronaut_spawn_spec.dart';
import 'package:space_game/game/entry_portal/entry_portal_spawn_spec.dart';
import 'package:space_game/game/mining/mineral_spawn_spec.dart';
import 'package:space_game/game/objective/objective_spawn_spec.dart';
import 'package:space_game/game/planet/planet_spawn_spec.dart';
import 'package:space_game/game/exit_portal/exit_portal_spawn_spec.dart';
import 'package:space_game/game/stage/generation/spawn_footprint.dart';
import 'package:space_game/game/stage/generation/stage_spawnpoint_spec.dart';

class StageBlueprint {
  StageBlueprint();

  late final StageSpawnpointSpec spawnPoint;
  late final EntryPortalSpawnSpec entryPortal;
  late final ExitPortalSpawnSpec portal;
  final List<PlanetSpawnSpec> planets = [];
  final List<AsteroidSpawnSpec> asteroids = [];
  final List<AstronautSpawnSpec> astronauts = [];
  final List<MineralSpawnSpec> minerals = [];
  final List<ObjectiveSpawnSpec> objectives = [];

  Iterable<SpawnFootprint> get occupied =>
      [spawnPoint.footprint, portal.footprint]
          .followedBy(planets.map((p) => p.footprint))
          .followedBy(asteroids.map((a) => a.footprint));
}

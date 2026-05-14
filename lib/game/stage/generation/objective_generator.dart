import 'dart:math';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/astronaut/astronaut_spawn_spec.dart';
import 'package:space_game/game/mining/mineral_spawn_spec.dart';
import 'package:space_game/game/objective/objective_spawn_spec.dart';
import 'package:space_game/game/stage/stage_blueprint.dart';
import 'package:space_game/game/stage/stage_config.dart';

class ObjectiveGenerator {
  ObjectiveGenerator({
    required this.assetManager,
    required this.config,
    required this.blueprint,
    required this.random,
  });

  final AssetManager assetManager;
  final StageConfig config;
  final StageBlueprint blueprint;
  final Random random;

  void generate() {
    for (int i = 0; i < config.rescueObjectiveCount; i++) {
      _generateRescueObjective();
    }
    for (int i = 0; i < config.fuelMineObjectiveCount; i++) {
      _generateFuelMineObjective();
    }
    for (int i = 0; i < config.healthMineObjectiveCount; i++) {
      _generateHealthMineObjective();
    }
  }

  void _generateRescueObjective() {
    final planet = blueprint.planets
        .where((p) => p.canHostAstronaut)
        .random(random);
    if (planet == null) return;

    final astronaut = AstronautSpawnSpec(
      astronautImage: assetManager.image('assets/astronaut/astronaut.png')!,
      shipWreckImage: assetManager.image('assets/astronaut/ship_wreck.png')!,
      planet: planet,
      planetAngle: random.nextDouble() * 2 * pi,
    );
    blueprint.astronauts.add(astronaut);

    blueprint.objectives.add(
      ObjectiveSpawnSpec(kind: .rescue, tier: .required, astronaut: astronaut),
    );
  }

  void _generateFuelMineObjective() {
    final planet = blueprint.planets.random(random);
    if (planet == null) return;

    final mineral = MineralSpawnSpec(
      mineralImage: assetManager.image('assets/minerals/fuel_mineral.png')!,
      planet: planet,
      planetAngle: random.nextDouble() * 2 * pi,
      resourceType: .fuel,
      volume: 250,
    );
    blueprint.minerals.add(mineral);

    blueprint.objectives.add(
      ObjectiveSpawnSpec(kind: .mine, tier: .optional, mineral: mineral),
    );
  }

  void _generateHealthMineObjective() {
    final planet = blueprint.planets.random(random);
    if (planet == null) return;

    final mineral = MineralSpawnSpec(
      mineralImage: assetManager.image('assets/minerals/health_mineral.png')!,
      planet: planet,
      planetAngle: random.nextDouble() * 2 * pi,
      resourceType: .health,
      volume: 50,
    );
    blueprint.minerals.add(mineral);

    blueprint.objectives.add(
      ObjectiveSpawnSpec(kind: .mine, tier: .optional, mineral: mineral),
    );
  }
}

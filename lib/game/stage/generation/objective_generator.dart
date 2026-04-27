import 'dart:math';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/astronaut/astronaut_spawn_spec.dart';
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

  Future<void> generate() async {
    // for (int i = 0; i < config.objectiveCount; i++) {
    //   await _generateRescueObjective();
    // }
  }

  Future<void> _generateRescueObjective() async {
    final planet = blueprint.planets
        .where((p) => p.canHostAstronaut)
        .random(random);
    if (planet == null) return;

    final astronaut = AstronautSpawnSpec(
      image: await assetManager.loadImage('assets/atlas.png'),
      planet: planet,
      planetAngle: random.nextDouble() * 2 * pi,
    );
    blueprint.astronauts.add(astronaut);

    blueprint.objectives.add(
      ObjectiveSpawnSpec(kind: .rescue, tier: .required, astronaut: astronaut),
    );
  }
}

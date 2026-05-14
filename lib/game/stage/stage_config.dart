import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/alien_type.dart';

class StageConfig {
  const StageConfig({
    required this.stageSize,
    required this.rescueObjectiveCount,
    required this.fuelMineObjectiveCount,
    required this.healthMineObjectiveCount,
    required this.regionPlanetCount,
    required this.difficultyStages,
  });

  final Vector2 stageSize;
  final int rescueObjectiveCount;
  final int fuelMineObjectiveCount;
  final int healthMineObjectiveCount;
  final int regionPlanetCount;
  final List<DifficultyStage> difficultyStages;
}

class DifficultyStage {
  const DifficultyStage({required this.timer, required this.alienSpawners});

  final double timer;
  final List<AlienSpawnConfig> alienSpawners;
}

class AlienSpawnConfig {
  const AlienSpawnConfig({required this.type, required this.delay});

  final AlienType type;
  final double delay;
}

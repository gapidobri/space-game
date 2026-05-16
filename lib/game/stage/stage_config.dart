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

  factory StageConfig.fromJson(Map<String, dynamic> json) => StageConfig(
    stageSize: Vector2(json['stageSize']['x'], json['stageSize']['y']),
    rescueObjectiveCount: json['rescueObjectiveCount'],
    fuelMineObjectiveCount: json['fuelMineObjectiveCount'],
    healthMineObjectiveCount: json['healthMineObjectiveCount'],
    regionPlanetCount: json['regionPlanetCount'],
    difficultyStages: (json['difficultyStages'] as List)
        .map((s) => DifficultyStage.fromJson(s))
        .toList(),
  );

  Map<String, dynamic> toJson() => {
    'stageSize': {'x': stageSize.x, 'y': stageSize.y},
    'rescueObjectiveCount': rescueObjectiveCount,
    'fuelMineObjectiveCount': fuelMineObjectiveCount,
    'healthMineObjectiveCount': healthMineObjectiveCount,
    'regionPlanetCount': regionPlanetCount,
    'difficultyStages': difficultyStages.map((s) => s.toJson()).toList(),
  };
}

class DifficultyStage {
  const DifficultyStage({required this.timer, required this.alienSpawners});

  final double timer;
  final List<AlienSpawnConfig> alienSpawners;

  factory DifficultyStage.fromJson(Map<String, dynamic> json) =>
      DifficultyStage(
        timer: json['timer'],
        alienSpawners: (json['alienSpawners'] as List)
            .map(
              (c) => AlienSpawnConfig(
                type: AlienType.values.firstWhere(
                  (t) => t.toString() == c['type'],
                ),
                delay: c['delay'],
              ),
            )
            .toList(),
      );

  Map<String, dynamic> toJson() => {
    'timer': timer,
    'alienSpawners': alienSpawners
        .map((c) => {'type': c.type.toString(), 'delay': c.delay})
        .toList(),
  };
}

class AlienSpawnConfig {
  const AlienSpawnConfig({required this.type, required this.delay});

  final AlienType type;
  final double delay;

  factory AlienSpawnConfig.fromJson(Map<String, dynamic> json) =>
      AlienSpawnConfig(
        type: AlienType.values.firstWhere((t) => t.toString() == json['type']),
        delay: json['delay'],
      );

  Map<String, dynamic> toJson() => {'type': type.toString(), 'delay': delay};
}

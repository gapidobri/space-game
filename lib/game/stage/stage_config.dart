import 'package:gamengine/gamengine.dart';

class StageConfig {
  const StageConfig({
    required this.stageSize,
    required this.objectiveCount,
    required this.regionPlanetCount,
  });

  final Vector2 stageSize;
  final int objectiveCount;
  final int regionPlanetCount;
}

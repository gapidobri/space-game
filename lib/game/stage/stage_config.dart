import 'package:gamengine/gamengine.dart';

class StageConfig {
  const StageConfig({required this.stageSize, required this.objectiveCount});

  final Vector2 stageSize;
  final int objectiveCount;
}

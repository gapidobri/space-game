import 'package:space_game/game/run/components/run_state.dart';
import 'package:space_game/game/stage/components/stage_state.dart';

class HudData {
  const HudData({
    this.runTimer,
    this.stageTimer,
    this.stageIndex,
    this.loadingOverlayOpacity = 1.0,
    this.fuel = 1.0,
    this.health = 1.0,
    this.requiredObjectives = const [],
    this.optionalObjectives = const [],
    this.runPhase,
    this.stagePhase,
  });

  final double loadingOverlayOpacity;

  final double fuel;
  final double health;

  final List<ObjectiveData> requiredObjectives;
  final List<ObjectiveData> optionalObjectives;

  final int? stageIndex;
  final double? runTimer;
  final double? stageTimer;

  final RunPhase? runPhase;
  final StagePhase? stagePhase;
}

class ObjectiveData {
  ObjectiveData({
    required this.name,
    required this.completed,
    required this.total,
  });

  final String name;
  int completed;
  int total;
}

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/rocket/components/rocket_location.dart';
import 'package:space_game/game/run/components/run_state.dart';
import 'package:space_game/game/stage/components/stage_state.dart';

class HudData {
  const HudData({
    this.loading = true,
    this.maxFuel = 0,
    this.fuel = 0,
    this.maxHealth = 0,
    this.health = 0,
    this.rocketLocation = const RocketLocationInSpace(),
    this.canRescue = false,
    this.minables = const [],
    this.objectives = const [],
    this.runPhase,
    this.stagePhase,
  });

  final bool loading;

  final double maxFuel;
  final double fuel;

  final double maxHealth;
  final double health;

  final RocketLocation rocketLocation;

  final bool canRescue;
  final List<Entity> minables;

  final List<ObjectiveData> objectives;

  final RunPhase? runPhase;
  final StagePhase? stagePhase;
}

class ObjectiveData {
  const ObjectiveData({required this.name, required this.completed});

  final String name;
  final bool completed;
}

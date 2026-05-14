import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/objective/components/objective.dart';
import 'package:space_game/game/run/components/current_stage.dart';
import 'package:space_game/game/run/components/loading_overlay_state.dart';
import 'package:space_game/game/run/components/run_state.dart';
import 'package:space_game/game/run/run_tag.dart';
import 'package:space_game/game/shared/damage/health.dart';
import 'package:space_game/game/hud/hud_data.dart';
import 'package:space_game/game/rocket/components/fuel_tank.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';
import 'package:space_game/game/stage/components/stage_state.dart';

HudData projectHudData(World world) {
  final run = world.query<RunTag>().firstOrNull;
  final rocket = world.query<RocketTag>().firstOrNull;
  final fuelTank = rocket?.get<FuelTank>();
  final health = rocket?.get<Health>();
  final objectives = world.query<Objective>().map((o) => o.get<Objective>());

  final runState = run?.get<RunState>();

  final stage = run?.get<CurrentStage>().stage;
  final stageState = stage?.get<StageState>();

  final requiredObjectiveMap = <ObjectiveKind, ObjectiveData>{};
  final optionalObjectiveMap = <ObjectiveKind, ObjectiveData>{};
  for (final objective in objectives) {
    final objectiveData = ObjectiveData(
      name: switch (objective.kind) {
        .mine => 'Mine resources',
        .rescue => 'Rescue astronaut',
      },
      completed: objective.completed ? 1 : 0,
      total: 1,
    );

    switch (objective.tier) {
      case .required:
        final o = requiredObjectiveMap[objective.kind];
        if (o == null) {
          requiredObjectiveMap[objective.kind] = objectiveData;
        } else {
          o.total++;
          if (objective.completed) {
            o.completed++;
          }
        }
        break;

      case .optional:
        final o = optionalObjectiveMap[objective.kind];

        if (o == null) {
          optionalObjectiveMap[objective.kind] = objectiveData;
        } else {
          o.total++;
          if (objective.completed) {
            o.completed++;
          }
        }
        break;
    }
  }

  return HudData(
    runTimer: runState?.timer,
    stageTimer: stageState?.timer,
    stageIndex: runState?.stageIndex,
    loadingOverlayOpacity: run?.get<LoadingOverlayState>().opacity ?? 1.0,
    fuel: fuelTank == null ? 0 : fuelTank.fuel / fuelTank.maxFuel,
    health: health == null ? 0 : health.percentage,
    requiredObjectives: requiredObjectiveMap.values.toList(),
    optionalObjectives: optionalObjectiveMap.values.toList(),
    runPhase: world.query<RunState>().firstOrNull?.get<RunState>().phase,
    stagePhase: world.query<StageState>().firstOrNull?.get<StageState>().phase,
  );
}

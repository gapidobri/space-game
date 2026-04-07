import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/astronaut/astronaut_tag.dart';
import 'package:space_game/game/objective/components/objective.dart';
import 'package:space_game/game/run/components/run_state.dart';
import 'package:space_game/game/shared/damage/health.dart';
import 'package:space_game/game/hud/hud_data.dart';
import 'package:space_game/game/mining/resource_node.dart';
import 'package:space_game/game/rocket/components/eva.dart';
import 'package:space_game/game/rocket/components/fuel_tank.dart';
import 'package:space_game/game/rocket/components/rocket_location.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';
import 'package:space_game/game/stage/components/stage_state.dart';

HudData projectHudData(World world) {
  final runState = world.tryGetComponent<RunState>();

  final rocket = world.query<RocketTag>().first;
  final fuelTank = rocket.get<FuelTank>();
  final health = rocket.get<Health>();
  final rocketLocationStore = rocket.get<RocketLocationStore>();
  final eva = rocket.get<Eva>();
  final objectives = world.query<Objective>().map((o) => o.get<Objective>());

  return HudData(
    loading: <RunPhase>{
      .stageEnter,
      .stageExit,
      .stageTransition,
    }.contains(runState?.phase),
    maxFuel: fuelTank.maxFuel,
    fuel: fuelTank.fuel,
    maxHealth: health.maxHealth,
    health: health.currentHealth,
    rocketLocation: rocketLocationStore.location,
    canRescue: eva.interactables.any((e) => e.has<AstronautTag>()),
    minables: eva.interactables.where((e) => e.has<ResourceNode>()).toList(),
    objectives: objectives
        .map(
          (o) => ObjectiveData(
            name: switch (o.kind) {
              .mine => 'Mine resource',
              .rescue => 'Rescue astronaut',
            },
            completed: o.completed,
          ),
        )
        .toList(),
    runPhase: world.query<RunState>().firstOrNull?.get<RunState>().phase,
    stagePhase: world.query<StageState>().firstOrNull?.get<StageState>().phase,
  );
}

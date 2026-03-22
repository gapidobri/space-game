import 'dart:math' as math;

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/shared/damage/health.dart';
import 'package:space_game/game/interaction/interaction_event.dart';
import 'package:space_game/game/mining/drill.dart';
import 'package:space_game/game/mining/resource_node.dart';
import 'package:space_game/game/rocket/components/eva.dart';
import 'package:space_game/game/rocket/components/fuel_tank.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';

class MiningSystem extends System {
  MiningSystem({super.priority, required this.eventBus});

  final EventBus eventBus;

  @override
  void update(double dt, World world, Commands commands) {
    final rocket = world.query<RocketTag>().firstOrNull;
    if (rocket == null) return;

    final eva = rocket.get<Eva>();
    final drill = rocket.get<Drill>();

    if (!eva.interactables.contains(drill.drillingResource)) {
      drill.drillingResource = null;
    }

    for (final event in eventBus.read<InteractionEvent>()) {
      if (!event.entity.has<ResourceNode>()) continue;

      drill.drillingResource = event.entity;
    }

    final resource = drill.drillingResource;
    if (resource == null) return;

    final minable = resource.get<ResourceNode>();

    var gain = math.min(drill.drillSpeed * dt, minable.remaining);

    switch (minable.resourceType) {
      case ResourceType.fuel:
        final fuelTank = rocket.get<FuelTank>();
        gain = math.min(gain, fuelTank.maxFuel - fuelTank.fuel);
        fuelTank.fuel += gain;
        break;

      case ResourceType.health:
        final health = rocket.get<Health>();
        gain = math.min(gain, health.maxHealth - health.currentHealth);
        health.currentHealth += gain;
        break;
    }

    if (gain == 0) {
      drill.drillingResource = null;
      return;
    }

    minable.remaining -= gain;

    if (minable.remaining <= 0) {
      commands.despawn(drill.drillingResource!);
      drill.drillingResource = null;
    }
  }
}

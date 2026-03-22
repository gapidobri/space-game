import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/astronaut/astronaut_tag.dart';
import 'package:space_game/game/shared/damage/health.dart';
import 'package:space_game/game/hud/hud_data.dart';
import 'package:space_game/game/mining/resource_node.dart';
import 'package:space_game/game/rocket/components/eva.dart';
import 'package:space_game/game/rocket/components/fuel_tank.dart';
import 'package:space_game/game/rocket/components/rocket_location.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';
import 'package:space_game/game/utils.dart';

HudData projectHudData(World world) {
  final rocket = world.query<RocketTag>().first;
  final fuelTank = rocket.get<FuelTank>();
  final health = rocket.get<Health>();
  final rocketLocationStore = rocket.get<RocketLocationStore>();
  final eva = rocket.get<Eva>();

  return HudData(
    maxFuel: fuelTank.maxFuel,
    fuel: fuelTank.fuel,
    maxHealth: health.maxHealth,
    health: health.currentHealth,
    rocketLocation: rocketLocationStore.location,
    canRescue: eva.interactables.containsWhere((e) => e.has<AstronautTag>()),
    minables: eva.interactables.where((e) => e.has<ResourceNode>()).toList(),
  );
}

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/rocket/components/rocket_location.dart';

class HudData {
  const HudData({
    this.maxFuel = 0,
    this.fuel = 0,
    this.maxHealth = 0,
    this.health = 0,
    this.rocketLocation = const RocketLocationInSpace(),
    this.canRescue = false,
    this.minables = const [],
  });

  final double maxFuel;
  final double fuel;

  final double maxHealth;
  final double health;

  final RocketLocation rocketLocation;

  final bool canRescue;
  final List<Entity> minables;
}

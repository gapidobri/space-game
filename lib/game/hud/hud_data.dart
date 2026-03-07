import 'package:space_game/game/rocket/components/rocket_location.dart';

class HudData {
  const HudData({
    this.maxFuel = 0,
    this.fuel = 0,
    this.rocketLocation = const RocketLocationInSpace(),
  });

  final double maxFuel;
  final double fuel;

  final RocketLocation rocketLocation;
}

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/astronaut/astronaut_location.dart';
import 'package:space_game/game/rocket/components/eva.dart';
import 'package:space_game/game/rocket/astronaut_rescue/rescue_attempt_event.dart';
import 'package:space_game/game/rocket/rocket.dart';

class AstronautRescueSystem extends System {
  AstronautRescueSystem({super.priority, required this.eventBus});

  final EventBus eventBus;

  @override
  void update(double dt, World world, Commands commands) {
    final rocket = world.query<RocketTag>().firstOrNull;
    if (rocket == null) return;

    for (final rescueAttempt in eventBus.read<RescueAttemptEvent>()) {
      final astronaut = rescueAttempt.astronaut;

      final location = astronaut.get<AstronautLocation>();
      if (location.type is! AstronautLocationOnPlanet) {
        continue;
      }

      final rocketT = rocket.get<Transform>();
      final eva = rocket.get<Eva>();

      final astronautT = astronaut.get<Transform>();

      final distance = rocketT.position.distanceTo(astronautT.position);

      if (distance > eva.maxRescueRange) {
        continue;
      }

      location.type = AstronautLocationInRocket();
    }
  }
}

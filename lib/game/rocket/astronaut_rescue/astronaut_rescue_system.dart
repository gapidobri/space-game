import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/astronaut/astronaut.dart';
import 'package:space_game/game/astronaut/astronaut_location.dart';
import 'package:space_game/game/rocket/components/eva.dart';
import 'package:space_game/game/rocket/astronaut_rescue/rescue_attempt_event.dart';
import 'package:space_game/game/rocket/components/rocket_location.dart';
import 'package:space_game/game/rocket/rocket.dart';

class AstronautRescueSystem extends System {
  AstronautRescueSystem({super.priority, required this.eventBus});

  final EventBus eventBus;

  @override
  void update(double dt, World world, Commands commands) {
    final rocket = world.query<RocketTag>().firstOrNull;
    if (rocket == null) return;

    final rocketLocation = rocket.get<RocketLocationStore>().location;
    if (rocketLocation is! RocketLocationLanded) return;

    for (final astronaut in world.query<AstronautTag>()) {
      final locationStore = astronaut.get<AstronautLocationStore>();
      final location = locationStore.location;

      if (location is! AstronautLocationOnPlanet ||
          location.planet != rocketLocation.planet) {
        continue;
      }

      final rocketT = rocket.get<Transform>();
      final eva = rocket.get<Eva>();

      final astronautT = astronaut.get<Transform>();

      final distance = rocketT.position.distanceTo(astronautT.position);

      if (distance > eva.maxRescueRange) {
        continue;
      }

      if (eventBus.read<RescueAttemptEvent>().isNotEmpty) {
        locationStore.location = AstronautLocationInRocket();
      }
    }
  }
}

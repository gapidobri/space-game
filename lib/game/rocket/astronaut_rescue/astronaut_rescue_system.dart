import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/astronaut/astronaut.dart';
import 'package:space_game/game/astronaut/astronaut_location.dart';
import 'package:space_game/game/rocket/components/eva.dart';
import 'package:space_game/game/rocket/astronaut_rescue/rescue_attempt_event.dart';
import 'package:space_game/game/rocket/rocket.dart';

class AstronautRescueSystem extends System {
  AstronautRescueSystem({super.priority, required this.eventBus});

  final EventBus eventBus;

  @override
  void update(double dt, World world, Commands commands) {
    if (eventBus.read<RescueAttemptEvent>().isNotEmpty) {
      final rocket = world.query<RocketTag>().firstOrNull;
      if (rocket == null) return;

      final eva = rocket.get<Eva>();

      for (final entity in eva.interactables) {
        if (!entity.has<AstronautTag>()) continue;

        final locationStore = entity.get<AstronautLocationStore>();

        locationStore.location = AstronautLocationInRocket();
      }
    }
  }
}

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/astronaut/astronaut_tag.dart';
import 'package:space_game/game/astronaut/astronaut_location.dart';
import 'package:space_game/game/interaction/interaction_event.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';

class AstronautRescueSystem extends System {
  AstronautRescueSystem({super.priority, required this.eventBus});

  final EventBus eventBus;

  @override
  void update(double dt, World world, Commands commands) {
    final rocket = world.query<RocketTag>().firstOrNull;
    if (rocket == null) return;

    for (final event in eventBus.read<InteractionEvent>()) {
      final entity = event.entity;

      if (!entity.has<AstronautTag>()) continue;

      entity.get<AstronautLocationStore>().location =
          AstronautLocationInRocket();
    }
  }
}

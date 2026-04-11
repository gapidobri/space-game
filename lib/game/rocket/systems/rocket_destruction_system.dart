import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/rocket/events/rocket_destroyed_event.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';
import 'package:space_game/game/shared/damage/health.dart';

class RocketDestructionSystem extends System {
  RocketDestructionSystem({super.priority, required this.eventBus});

  final EventBus eventBus;

  @override
  void update(double dt, World world, Commands commands) {
    final rocket = world.query<RocketTag>().firstOrNull;
    if (rocket == null) return;

    final health = rocket.get<Health>();
    if (health.currentHealth <= 0) {
      eventBus.emit(RocketDestroyedEvent());
      commands.despawn(rocket);
    }
  }
}

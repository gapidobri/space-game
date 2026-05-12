import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/events/alien_destroyed_event.dart';
import 'package:space_game/game/alien/destruction/alien_destruction_state.dart';
import 'package:space_game/game/alien/alien_tag.dart';
import 'package:space_game/game/shared/damage/health.dart';

class AlienDestructionSystem extends System {
  AlienDestructionSystem({super.priority, required this.eventBus});

  final EventBus eventBus;

  @override
  void update(double dt, World world, Commands commands) {
    for (final entity in world.query<AlienTag>()) {
      final health = entity.get<Health>();
      if (health.currentHealth > 0) continue;

      final destructionState = entity.get<AlienDestructionState>();
      final collider = entity.get<RectangleCollider>();

      switch (destructionState.status) {
        case .alive:
          collider.enabled = false;
          entity.get<RigidBody>().isStatic = true;

          eventBus.emit(AlienDestroyedEvent(alien: entity));

          destructionState.status = .destroying;
          break;

        case .destroying:
          // Wait for animation system to set state to dead
          break;

        case .dead:
          commands.despawn(entity);
          break;
      }
    }
  }
}

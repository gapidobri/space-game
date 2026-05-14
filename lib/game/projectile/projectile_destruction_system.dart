import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/projectile/projectile_tag.dart';

class ProjectileDestructionSystem extends System {
  ProjectileDestructionSystem({super.priority, required this.eventBus});

  final EventBus eventBus;

  @override
  void update(double dt, World world, Commands commands) {
    for (final event in eventBus.read<CollisionEvent>()) {
      for (final entity in event.entities) {
        if (!entity.has<ProjectileTag>()) continue;
        commands.despawn(entity);
      }
    }
  }
}

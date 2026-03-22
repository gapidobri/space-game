import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/alien_tag.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';

class AlienMovementSystem extends System {
  @override
  void update(double dt, World world, Commands commands) {
    final rocket = world.query<RocketTag>().firstOrNull;
    if (rocket == null) return;

    final targetTransform = rocket.get<Transform>();

    for (final alien in world.query<AlienTag>()) {
      final transform = alien.get<Transform>();
      final rigidBody = alien.get<RigidBody>();

      final targetDirection =
          (targetTransform.position - transform.position).normalized() * 10;

      rigidBody.accumulatedForce.add(targetDirection);
    }
  }
}

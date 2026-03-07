import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/alien.dart';

class AlienMovementSystem extends System {
  AlienMovementSystem({super.priority, required this.target});
  final Entity target;

  @override
  void update(double dt, World world, Commands commands) {
    final targetTransform = target.get<Transform>();

    for (final alien in world.query<AlienTag>()) {
      final transform = alien.get<Transform>();
      final rigidBody = alien.get<RigidBody>();

      final targetDirection =
          (targetTransform.position - transform.position).normalized() * 10;

      rigidBody.accumulatedForce.add(targetDirection);
    }
  }
}

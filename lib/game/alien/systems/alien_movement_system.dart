import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/alien.dart';

class AlienMovementSystem extends System {
  final Entity target;
  final World world;

  AlienMovementSystem({
    super.priority,
    required this.target,
    required this.world,
  });

  @override
  void update(double dt) {
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

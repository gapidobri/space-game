import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/alien_tag.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';

const avoidDistance = 100.0;
const thrust = 500.0;

class AlienChaseSystem extends System {
  @override
  void update(double dt, World world, Commands commands) {
    final rocket = world.query<RocketTag>().firstOrNull;
    if (rocket == null) return;

    final rocketTransform = rocket.get<Transform>();

    for (final alien in world.query<AlienTag>()) {
      final transform = alien.get<Transform>();
      final rigidBody = alien.get<RigidBody>();

      final toRocket = rocketTransform.position - transform.position;
      final distance = toRocket.length;
      final dir = toRocket.normalized();

      final v = rigidBody.velocity;

      final forwardSpeed = v.dot(dir);

      final forwardVel = dir * forwardSpeed;

      final sideVel = v - forwardVel;

      final desiredVelocity = distance - avoidDistance;

      rigidBody.accumulatedForce.addScaled(-sideVel.normalized(), 50.0);

      if (rigidBody.velocity.length > desiredVelocity) {
        rigidBody.accumulatedForce.addScaled(-v.normalized(), thrust);
      } else {
        rigidBody.accumulatedForce.addScaled(dir, thrust);
      }
    }
  }
}

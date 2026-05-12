import 'dart:math';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/projectile/homing.dart';

const stiffness = 20.0;
const damping = 8.0;

class ProjectileHomingSystem extends System {
  @override
  void update(double dt, World world, Commands commands) {
    for (final projectile in world.query<Homing>()) {
      final homing = projectile.get<Homing>();
      final transform = projectile.get<Transform>();
      final rigidBody = projectile.get<RigidBody>();

      final targetTransform = homing.target.get<Transform>();

      final rocketDir = (targetTransform.position - transform.position)
          .normalized();

      final forward = transform.direction;

      final desiredDir = rocketDir.normalized();

      final angleDiff = atan2(
        forward.x * desiredDir.y - forward.y * desiredDir.x,
        forward.dot(desiredDir),
      );

      rigidBody.angularAcceleration =
          angleDiff * stiffness - rigidBody.angularVelocity * damping;

      rigidBody.velocity.setFrom(
        transform.direction * rigidBody.velocity.length,
      );
    }
  }
}

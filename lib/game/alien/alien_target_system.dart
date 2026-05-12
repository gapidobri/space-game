import 'dart:math';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/alien_tag.dart';
import 'package:space_game/game/alien/weapon/weapon.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';

const stiffness = 20.0;
const damping = 8.0;

class AlienTargetSystem extends System {
  @override
  void update(double dt, World world, Commands commands) {
    final rocket = world.query<RocketTag>().firstOrNull;
    if (rocket == null) return;

    final rocketTransform = rocket.get<Transform>();

    for (final alien in world.query<AlienTag>()) {
      final transform = alien.get<Transform>();
      final rigidBody = alien.get<RigidBody>();
      final weapon = alien.get<Weapon>();

      final rocketDir = (rocketTransform.position - transform.position)
          .normalized();

      final forward = transform.direction;

      Vector2 desiredDir;
      switch (weapon.projectileType) {
        case .bullet:
          final desiredWorldVel = rocketDir * weapon.projectileSpeed;

          final shotVelocity = desiredWorldVel - rigidBody.velocity;

          desiredDir = shotVelocity.normalized();
          break;

        case .torpedo:
          desiredDir = rocketDir;
          break;
      }

      final angleDiff = atan2(
        forward.x * desiredDir.y - forward.y * desiredDir.x,
        forward.dot(desiredDir),
      );

      rigidBody.angularAcceleration =
          angleDiff * stiffness - rigidBody.angularVelocity * damping;
    }
  }
}

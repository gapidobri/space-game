import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/projectile/homing.dart';
import 'package:space_game/game/projectile/projectile_tag.dart';

class ProjectileOrientationSystem extends System {
  @override
  void update(double dt, World world, Commands commands) {
    for (final projectile in world.query<ProjectileTag>()) {
      if (projectile.has<Homing>()) continue;

      final transform = projectile.get<Transform>();
      final rigidBody = projectile.get<RigidBody>();

      transform.rotation = Vector2(0, -1).angleToSigned(rigidBody.velocity);
    }
  }
}

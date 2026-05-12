import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/alien_state.dart';
import 'package:space_game/game/alien/alien_tag.dart';
import 'package:space_game/game/alien/weapon/weapon.dart';
import 'package:space_game/game/projectile/events/projectile_spawn_request_event.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';

const _shootingDistance = 500;

class AlienShootingSystem extends System {
  AlienShootingSystem({required this.eventBus});

  final EventBus eventBus;

  @override
  void update(double dt, World world, Commands commands) {
    final rocket = world.query<RocketTag>().firstOrNull;
    if (rocket == null) return;

    final rocketTransform = rocket.get<Transform>();

    for (final alien in world.query<AlienTag>()) {
      final transform = alien.get<Transform>();
      final state = alien.get<AlienState>();

      final distance = (rocketTransform.position - transform.position).length;

      final shouldShoot = distance < _shootingDistance;

      state.shooting = shouldShoot;
      if (!shouldShoot) continue;

      final weapon = alien.get<Weapon>();
      final animatedSprite = alien.get<AnimatedSprite>();

      final lastFrame = weapon.lastFrame;
      weapon.lastFrame = animatedSprite.currentFrame;

      final offset = weapon.shootFrames[animatedSprite.currentFrame];
      if (lastFrame == animatedSprite.currentFrame || offset == null) {
        continue;
      }

      eventBus.emit(
        ProjectileSpawnRequestEvent(
          shooter: alien,
          offset: offset,
          velocity: weapon.projectileSpeed,
        ),
      );
    }
  }
}

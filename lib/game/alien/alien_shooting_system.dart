import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/alien_state.dart';
import 'package:space_game/game/alien/alien_tag.dart';
import 'package:space_game/game/alien/weapon/weapon.dart';
import 'package:space_game/game/projectile/events/projectile_spawn_request_event.dart';

class AlienShootingSystem extends System {
  AlienShootingSystem({required this.eventBus});

  final EventBus eventBus;

  @override
  int get priority => 740;

  @override
  void update(double dt, World world, Commands commands) {
    for (final alien in world.query<AlienTag>()) {
      final animatedSprite = alien.get<AnimatedSprite>();
      final state = alien.get<AlienState>();
      final weapon = alien.tryGet<Weapon>();
      if (weapon == null) continue;

      if (!state.shooting) continue;

      final lastFrame = weapon.lastFrame;
      weapon.lastFrame = animatedSprite.currentFrame;

      final offsets = weapon.shootFrames[animatedSprite.currentFrame];
      if (lastFrame == animatedSprite.currentFrame ||
          offsets == null ||
          offsets.isEmpty) {
        continue;
      }

      for (final offset in offsets) {
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
}

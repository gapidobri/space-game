import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/alien_state.dart';
import 'package:space_game/game/alien/alien_tag.dart';
import 'package:space_game/game/alien/weapon/weapon.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';

const _shootingDistance = 500;

class AlienShootingDecisionSystem extends System {
  @override
  int get priority => 750;

  @override
  void update(double dt, World world, Commands commands) {
    final rocket = world.query<RocketTag>().firstOrNull;
    if (rocket == null) return;

    final rocketTransform = rocket.get<Transform>();

    for (final alien in world.query<AlienTag>()) {
      final transform = alien.get<Transform>();
      final state = alien.get<AlienState>();
      final weapon = alien.tryGet<Weapon>();
      if (weapon == null) continue;

      final distance = transform.position.distanceTo(rocketTransform.position);

      if (state.shooting ||
          weapon.cooldownRemaining > 0 ||
          distance > _shootingDistance) {
        continue;
      }

      state.shooting = true;
      weapon.cooldownRemaining = weapon.cooldown;
    }
  }
}

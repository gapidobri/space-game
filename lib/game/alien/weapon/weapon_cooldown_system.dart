import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/weapon/weapon.dart';

class WeaponCooldownSystem extends System {
  @override
  void update(double dt, World world, Commands commands) {
    for (final entity in world.query<Weapon>()) {
      final weapon = entity.get<Weapon>();
      if (weapon.cooldownRemaining > 0) {
        weapon.cooldownRemaining -= dt;
        if (weapon.cooldownRemaining < 0) {
          weapon.cooldownRemaining = 0;
        }
      }
    }
  }
}

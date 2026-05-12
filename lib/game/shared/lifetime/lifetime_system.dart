import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/shared/lifetime/lifetime.dart';

class LifetimeSystem extends System {
  @override
  void update(double dt, World world, Commands commands) {
    for (final entity in world.query<Lifetime>()) {
      final lifetime = entity.get<Lifetime>();
      lifetime.remainingTime -= dt;
      if (lifetime.remainingTime < 0) {
        commands.despawn(entity);
      }
    }
  }
}

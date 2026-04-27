import 'package:flutter/services.dart';
import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';
import 'package:space_game/game/shared/damage/health.dart';

class RocketVisualSystem extends System {
  @override
  void update(double dt, World world, Commands commands) {
    final rocket = world.query<RocketTag>().firstOrNull;
    if (rocket == null) return;

    _updateDamage(rocket);
  }

  void _updateDamage(Entity rocket) {
    final sprite = rocket.get<Sprite>();
    final health = rocket.get<Health>();
    final i = 4 - (health.percentage * 4).ceil();
    sprite.sourceRect = Rect.fromLTWH(i * 48.0, 48, 48, 48);
  }
}

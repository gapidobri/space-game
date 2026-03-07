import 'dart:math' as math;

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/astronaut/astronaut.dart';
import 'package:space_game/game/astronaut/astronaut_location.dart';

class AstronautSystem extends System {
  AstronautSystem({super.priority});

  @override
  void update(double dt, World world, Commands commands) {
    for (final astronaut in world.query<AstronautTag>()) {
      final transform = astronaut.get<Transform>();
      final location = astronaut.get<AstronautLocation>();
      final sprite = astronaut.get<Sprite>();

      final locationType = location.type;

      if (locationType is AstronautLocationInRocket) {
        sprite.visible = false;
        return;
      }

      if (locationType is! AstronautLocationOnPlanet) {
        return;
      }

      final planet = locationType.planet;
      final planetTransform = planet.get<Transform>();
      final collider = planet.get<CircleCollider>();

      final angle = Vector2(
        math.cos(locationType.angle),
        math.sin(locationType.angle),
      );

      transform.position.setFrom(
        planetTransform.position + angle * collider.radius,
      );
    }
  }
}

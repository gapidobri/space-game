import 'dart:math' as math;

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/planet/occupancy/planet_occupant.dart';

class PlanetOccupancySystem extends System {
  @override
  void update(double dt, World world, Commands commands) {
    for (final entity in world.query2<Transform, PlanetOccupant>()) {
      final transform = entity.get<Transform>();
      final occupant = entity.get<PlanetOccupant>();

      final planetTransform = occupant.planet.get<Transform>();
      final collider = occupant.planet.get<CircleCollider>();

      final angle = Vector2(math.cos(occupant.angle), math.sin(occupant.angle));

      transform.position.setFrom(
        planetTransform.position + angle * (collider.radius + 20),
      );
      transform.rotation = occupant.angle + math.pi / 2;
    }
  }
}

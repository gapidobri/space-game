import 'dart:math';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/planet/planet_tag.dart';
import 'package:space_game/game/rocket/components/rocket_location.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';
import 'package:collection/collection.dart';

class LandingAssistanceSystem extends System {
  LandingAssistanceSystem({
    super.priority,
    required this.eventBus,
    this.landingAreaPadding = 50.0,
  });

  final EventBus eventBus;

  double landingAreaPadding;

  @override
  void update(double dt, World world, Commands commands) {
    final rocket = world.query<RocketTag>().firstOrNull;
    if (rocket == null) return;

    final locationStore = rocket.get<RocketLocationStore>();
    final transform = rocket.get<Transform>();
    final rigidBody = rocket.get<RigidBody>();

    final location = locationStore.location;
    if (location is RocketLocationLanded) {
      rigidBody.velocity.setZero();
      rigidBody.angularVelocity = 0;

      final planetRocketAngle = _calculatePlanetRocketAngle(
        transform,
        location.planet.get<Transform>(),
      );

      // rotate rocket perfectly upright after landing
      if (planetRocketAngle.abs() > 0.005) {
        transform.rotation -= planetRocketAngle * 2 * dt;
      }

      return;
    }

    for (final planet in world.query<PlanetTag>()) {
      final planetTransform = planet.get<Transform>();
      final collider = planet.get<CircleCollider>();

      final minDistance = collider.radius + landingAreaPadding;
      final currDistance =
          (planetTransform.position - transform.position).length;

      if (currDistance > minDistance || rigidBody.velocity.length > 10.0) {
        continue;
      }

      final planetRocketAngle = _calculatePlanetRocketAngle(
        transform,
        planetTransform,
      );

      final isColliding = eventBus.read<CollisionEvent>().any(
        (event) => event.includes(rocket) && event.includes(planet),
      );

      if (planetRocketAngle.abs() < 0.5 &&
          rigidBody.angularVelocity < 1 &&
          isColliding) {
        locationStore.location = RocketLocationLanded(planet: planet);
      }
    }
  }

  double _calculatePlanetRocketAngle(
    Transform rocketTransform,
    Transform planetTransform,
  ) {
    final tangent = rocketTransform.position - planetTransform.position;
    final angleToRocket = atan2(tangent.x, -tangent.y);
    return rocketTransform.rotation - angleToRocket;
  }
}

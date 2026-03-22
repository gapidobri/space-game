import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/shared/damage/health.dart';
import 'package:space_game/game/mining/drill.dart';
import 'package:space_game/game/rocket/components/eva.dart';
import 'package:space_game/game/rocket/components/fuel_tank.dart';
import 'package:space_game/game/rocket/components/rocket_location.dart';
import 'package:space_game/game/rocket/components/rocket_pilot.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';

Entity createRocket({required Image image}) {
  final entity = Entity();

  // identity
  entity.add(RocketTag());

  // physics
  entity.add(Transform());
  entity.add(RigidBody(mass: 10, momentOfInertia: 200));
  entity.add(
    RectangleCollider(halfWidth: 10, halfHeight: 20, restitution: 0.2),
  );

  // rendering
  entity.add(
    Sprite(image: image, sourceRect: Rect.fromLTWH(0, 50, 50, 50), z: 20),
  );

  // gameplay
  entity.add(
    RocketPilot(thrustForce: 500, rotationForce: 1000, boostMultiplier: 2),
  );
  entity.add(FuelTank(maxFuel: 100, fuel: 100));
  entity.add(RocketLocationStore(location: RocketLocationInSpace()));
  entity.add(Eva(maxInteractionRange: 100));
  entity.add(Health(maxHealth: 100));
  entity.add(Drill(drillSpeed: 5));

  // ui
  entity.add(CameraFollowTarget());

  return entity;
}

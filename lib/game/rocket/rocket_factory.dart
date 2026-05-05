import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/particle_system/particle_emitter.dart';
import 'package:space_game/game/shared/collision/collision_layers.dart';
import 'package:space_game/game/shared/damage/health.dart';
import 'package:space_game/game/mining/drill.dart';
import 'package:space_game/game/rocket/components/eva.dart';
import 'package:space_game/game/rocket/components/fuel_tank.dart';
import 'package:space_game/game/rocket/components/rocket_location.dart';
import 'package:space_game/game/rocket/components/rocket_engine.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';

Entity createRocket({required Asset<Image> image}) {
  final entity = Entity();

  // identity
  entity.add(RocketTag());

  // physics
  entity.add(Transform(scale: Vector2.all(2)));
  entity.add(RigidBody(mass: 10, momentOfInertia: 200));
  entity.add(
    RectangleCollider(
      halfWidth: 26,
      halfHeight: 26,
      restitution: 0.2,
      collisionLayer: rocketLayer,
    ),
  );

  // rendering
  entity.add(
    Sprite(image: image, sourceRect: Rect.fromLTWH(0, 48, 48, 48), z: 30),
  );

  // gameplay
  entity.add(
    RocketEngine(thrustForce: 500, rotationForce: 1000, boostMultiplier: 2),
  );
  entity.add(FuelTank(maxFuel: 500, fuel: 500));
  entity.add(RocketLocationStore(location: RocketLocationInSpace()));
  entity.add(Eva(maxInteractionRange: 100));
  entity.add(Health(maxHealth: 100));
  entity.add(Drill(drillSpeed: 5));

  // ui
  entity.add(CameraFollowTarget());

  return entity;
}

Entity createEngine({required Entity rocket, required Asset<Image> image}) {
  final entity = Entity();

  entity.add(Sprite(image: image, sourceRect: Rect.fromLTWH(0, 0, 48, 48)));

  entity.add(Transform(scale: Vector2.all(2)));
  entity.add(Parent(parent: rocket));
  entity.add(LocalTransform());

  return entity;
}

Entity createRocketParticleEmitter({required Entity rocket}) {
  final entity = Entity();

  entity.add(Transform());
  entity.add(LocalTransform(position: Vector2(0, 20)));
  entity.add(Parent(parent: rocket));

  entity.add(
    ParticleEmitter(
      enabled: false,
      spawnRate: 40,
      spawnCount: 2,
      colors: [
        Color(0xffff0000),
        Color.fromARGB(255, 255, 94, 0),
        Color.fromARGB(255, 255, 149, 0),
      ],
      initialVelocity: Vector2(0, 200),
      randomSpawnOffset: Vector2(2, 0),
      minLifetime: 0.2,
      maxLifetime: 1,
      turbulence: 0.25,
      particleSize: Size(4, 4),
      fadeOutTime: 0.2,
    ),
  );

  return entity;
}

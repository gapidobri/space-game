import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/projectile/homing.dart';
import 'package:space_game/game/projectile/projectile_tag.dart';
import 'package:space_game/game/shared/damage/damage_dealer.dart';
import 'package:space_game/game/shared/lifetime/lifetime.dart';

Entity createProjectile({
  required Asset<Image> image,
  required Vector2 position,
  required double rotation,
  required Vector2 velocity,
  Entity? parent,
}) {
  final entity = Entity();

  entity.add(ProjectileTag());

  entity.add(
    Transform()
      ..position.setFrom(position)
      ..rotation = rotation
      ..scale.setValues(2.0, 2.0),
  );

  entity.add(Sprite(image: image, z: 45));

  entity.add(PhysicsDebugOverride(enabled: false));

  entity.add(RigidBody(velocity: velocity, mass: 0.00001));

  if (parent != null) {
    entity.add(Parent(parent: parent));
  }

  return entity;
}

Entity createBullet({
  required Asset<Image> image,
  required Vector2 position,
  required double rotation,
  required Vector2 velocity,
  Entity? parent,
}) {
  final entity = createProjectile(
    image: image,
    position: position,
    rotation: rotation,
    velocity: velocity,
    parent: parent,
  );

  entity.add(AnimatedSprite(frameWidth: 4, frameHeight: 16, frameCount: 4));

  // entity.add(
  //   CircleCollider(
  //     radius: 1,
  //     collisionLayer: projectileLayer,
  //     collisionMask: defaultLayer | rocketLayer,
  //   ),
  // );

  entity.add(
    VelocityDamageDealer(damageMultiplier: 0.001, destroyOnCollision: true),
  );
  entity.add(Lifetime(remainingTime: 5));

  return entity;
}

Entity createTorpedo({
  required Asset<Image> image,
  required Vector2 position,
  required double rotation,
  required Vector2 velocity,
  required Entity target,
  Entity? parent,
}) {
  final entity = createProjectile(
    image: image,
    position: position,
    rotation: rotation,
    velocity: velocity,
    parent: parent,
  );

  entity.add(AnimatedSprite(frameWidth: 11, frameHeight: 32, frameCount: 3));

  entity.add(ConstantDamageDealer(damage: 10, destroyOnCollision: true));
  entity.add(Lifetime(remainingTime: 10));

  entity.add(Homing(target: target));

  return entity;
}

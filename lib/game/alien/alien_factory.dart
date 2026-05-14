import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/alien_state.dart';
import 'package:space_game/game/alien/animation/alien_animation_config.dart';
import 'package:space_game/game/alien/animation/alien_animation_state.dart';
import 'package:space_game/game/alien/destruction/alien_destruction_state.dart';
import 'package:space_game/game/alien/alien_tag.dart';
import 'package:space_game/game/alien/weapon/weapon.dart';
import 'package:space_game/game/shared/collision/collision_layers.dart';
import 'package:space_game/game/shared/damage/damage_dealer.dart';
import 'package:space_game/game/shared/damage/health.dart';

Entity createAlien({
  required Asset<Image> image,
  Vector2? position,
  Entity? parent,
}) {
  final entity = Entity();

  entity.add(AlienTag());

  entity.add(
    Transform()
      ..position.setFrom(position ?? Vector2.zero())
      ..scale.setFrom(Vector2.all(2.0)),
  );

  entity.add(AlienState());

  entity.add(AlienDestructionState());

  entity.add(
    Sprite(image: image, sourceRect: Rect.fromLTWH(0, 0, 64, 64), z: 50),
  );
  entity.add(
    AnimatedSprite(
      frameWidth: 64,
      frameHeight: 64,
      frameCount: 1,
      loop: false,
      playing: false,
    ),
  );
  entity.add(AlienAnimationState());

  entity.add(RigidBody(mass: 10));
  entity.add(
    RectangleCollider(
      halfHeight: 20,
      halfWidth: 20,
      collisionLayer: alienLayer,
      collisionMask: defaultLayer | rocketLayer | particleLayer | alienLayer,
    ),
  );

  entity.add(Health(maxHealth: 100));
  entity.add(VelocityDamageDealer(damageMultiplier: 0.1));

  if (parent != null) {
    entity.add(Parent(parent: parent));
  }

  return entity;
}

Entity createAlienFighter({
  required Asset<Image> image,
  Vector2? position,
  Entity? parent,
}) {
  final entity = createAlien(image: image, position: position, parent: parent);

  entity.add(
    AlienAnimationConfig(
      idleFrame: 0,
      destruction: AnimationConfig(firstFrame: 10, frameCount: 9),
      shooting: AnimationConfig(firstFrame: 0, frameCount: 6),
    ),
  );

  entity.add(
    Weapon(
      projectileSpeed: 500.0,
      projectileType: .bullet,
      shootFrames: {
        1: [Vector2(10, 0)],
        3: [Vector2(-10, 0)],
      },
    ),
  );

  return entity;
}

Entity createAlienTorpedo({
  required Asset<Image> image,
  Vector2? position,
  Entity? parent,
}) {
  final entity = createAlien(image: image, position: position, parent: parent);

  entity.add(
    AlienAnimationConfig(
      idleFrame: 0,
      destruction: AnimationConfig(firstFrame: 16, frameCount: 10),
      shooting: AnimationConfig(firstFrame: 0, frameCount: 16),
    ),
  );

  entity.add(
    Weapon(
      cooldown: 10,
      projectileSpeed: 100.0,
      projectileType: .torpedo,
      shootFrames: {
        4: [Vector2(18, -4)],
        6: [Vector2(-18, -4)],
        8: [Vector2(30, -4)],
        10: [Vector2(-30, -4)],
        12: [Vector2(42, -4)],
        14: [Vector2(-42, -4)],
      },
    ),
  );

  return entity;
}

Entity createAlienFrigate({
  required Asset<Image> image,
  Vector2? position,
  Entity? parent,
}) {
  final entity = createAlien(image: image, position: position, parent: parent);

  entity.add(
    AlienAnimationConfig(
      idleFrame: 0,
      destruction: AnimationConfig(firstFrame: 10, frameCount: 9),
      shooting: AnimationConfig(firstFrame: 0, frameCount: 6),
    ),
  );

  entity.add(
    Weapon(
      projectileSpeed: 300.0,
      projectileType: .bigBullet,
      shootFrames: {
        1: [Vector2(-30, 0), Vector2(30, 0)],
        3: [Vector2(-15, -15), Vector2(15, -15)],
      },
    ),
  );

  return entity;
}

Entity createAlienDreadnought({
  required Asset<Image> image,
  Vector2? position,
  Entity? parent,
}) {
  final entity = createAlien(image: image, position: position, parent: parent);

  entity.get<AnimatedSprite>()
    ..frameWidth = 128
    ..frameHeight = 128;

  entity.get<RectangleCollider>()
    ..halfWidth = 70
    ..halfHeight = 80;

  entity.add(
    AlienAnimationConfig(
      idleFrame: 0,
      destruction: AnimationConfig(firstFrame: 60, frameCount: 12),
      shooting: AnimationConfig(firstFrame: 0, frameCount: 60),
    ),
  );

  return entity;
}

import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/particle_system/particle.dart';
import 'package:space_game/game/shared/collision/collision_layers.dart';

Entity createParticle({
  required Vector2 position,
  required Size size,
  required double lifetime,
  required Color color,
  double rotation = 0,
  Vector2? initialVelocity,
  double fadeOutTime = 0,
  Entity? parent,
}) {
  final entity = Entity();

  entity.add(
    Transform()
      ..position.setFrom(position)
      ..rotation = rotation,
  );
  entity.add(
    RigidBody(
      mass: 0.000001,
      gravityScale: 0,
      velocity: initialVelocity?.clone(),
    ),
  );
  entity.add(
    RectangleShape(
      size: size,
      anchor: Offset(0.5, 0.5),
      paint: Paint()..color = color,
    ),
  );
  entity.add(
    RectangleCollider(
      halfWidth: size.width / 2,
      halfHeight: size.height / 2,
      collisionLayer: particleLayer,
      collisionMask: defaultLayer | rocketLayer,
    ),
  );
  entity.add(Particle(lifetime: lifetime, fadeOutTime: fadeOutTime));

  if (parent != null) {
    entity.add(Parent(parent: parent));
  }

  return entity;
}

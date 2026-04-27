import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/planet/planet_spawn_spec.dart';
import 'package:space_game/game/shared/damage/damage_dealer.dart';
import 'package:space_game/game/planet/atmosphere/atmosphere.dart';
import 'package:space_game/game/planet/planet_tag.dart';

Entity createPlanet({required PlanetSpawnSpec spec, Entity? parent}) {
  final PlanetSpawnSpec(:image, :position, :mass, :radius, :atmosphere) = spec;

  final entity = Entity();

  // identity
  entity.add(PlanetTag());

  // physics
  entity.add(Transform(position: position, scale: Vector2.all(3)));
  entity.add(RigidBody(isStatic: true));
  entity.add(GravitySource(mass: mass));
  entity.add(
    CircleCollider(
      radius: radius,
      staticFriction: 20,
      dynamicFriction: 20,
      restitution: 0.2,
    ),
  );
  if (atmosphere != null) {
    entity.add(
      Atmosphere(
        radius: atmosphere.radius,
        drag: atmosphere.drag,
        fuelRichness: atmosphere.fuelRichness,
      ),
    );
  }

  // rendering
  entity.add(Sprite(image: image, z: 10));

  // gameplay
  entity.add(VelocityDamageDealer(damageMultiplier: 0.1));
  if (atmosphere != null) {
    entity.add(
      CircleShape(
        radius: atmosphere.radius,
        paint: Paint()
          ..color = atmosphere.color
          ..maskFilter = MaskFilter.blur(BlurStyle.normal, 100),
      ),
    );
  }

  // cleanup
  if (parent != null) {
    entity.add(Parent(parent: parent));
  }

  return entity;
}

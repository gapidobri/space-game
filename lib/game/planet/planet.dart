import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/planet/atmosphere/atmosphere.dart';

class PlanetBuilder {
  final Vector2 position;
  final double mass;
  final Image image;
  final AtmosphereBuilder? atmosphere;

  const PlanetBuilder({
    required this.image,
    required this.position,
    required this.mass,
    this.atmosphere,
  });

  Entity build() {
    final entity = Entity();

    entity.add(
      Transform()
        ..position.setFrom(position)
        ..scale = Vector2.all(3),
    );

    entity.add(RigidBody(isStatic: true));
    entity.add(GravitySource(mass: mass));
    entity.add(
      CircleCollider(
        radius: 300,
        staticFriction: 20,
        dynamicFriction: 20,
        restitution: 0.2,
      ),
    );

    if (atmosphere != null) {
      entity.add(Atmosphere(radius: 500, drag: atmosphere!.drag));
      entity.add(
        CircleShape(
          radius: 500,
          paint: Paint()
            ..color = atmosphere!.color
            ..maskFilter = MaskFilter.blur(BlurStyle.normal, 100),
        ),
      );
    }

    entity.add(Sprite(image: image, z: 10));

    return entity;
  }
}

class AtmosphereBuilder {
  final double drag;
  final Color color;

  const AtmosphereBuilder({required this.drag, required this.color});
}

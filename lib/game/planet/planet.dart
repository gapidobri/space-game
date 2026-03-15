import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/damage/damage_dealer.dart';
import 'package:space_game/game/planet/atmosphere/atmosphere.dart';

class PlanetTag extends Component {}

class PlanetBuilder {
  const PlanetBuilder({
    required this.image,
    required this.position,
    required this.mass,
    this.atmosphere,
  });
  final Vector2 position;
  final double mass;
  final Image image;
  final AtmosphereBuilder? atmosphere;

  PlanetBuilder _copyWith({
    Image? image,
    Vector2? position,
    double? mass,
    AtmosphereBuilder? atmosphere,
  }) => PlanetBuilder(
    image: image ?? this.image,
    position: position ?? this.position,
    mass: mass ?? this.mass,
    atmosphere: atmosphere ?? this.atmosphere,
  );

  PlanetBuilder withAtmosphere(AtmosphereBuilder atmosphere) =>
      _copyWith(atmosphere: atmosphere);

  Entity build() {
    final entity = Entity();
    entity.add(PlanetTag());

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
    entity.add(VelocityDamageDealer(damageMultiplier: 0.1));

    if (atmosphere != null) {
      entity.add(
        Atmosphere(radius: 500, drag: atmosphere!.drag, fuelRichness: 2),
      );
      entity.add(
        CircleShape(
          radius: atmosphere!.radius,
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
  const AtmosphereBuilder({
    required this.radius,
    required this.drag,
    required this.color,
  });
  final double radius;
  final double drag;
  final Color color;
}

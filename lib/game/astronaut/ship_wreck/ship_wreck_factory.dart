import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/particle_system/particle_emitter.dart';
import 'package:space_game/game/planet/occupancy/planet_occupant.dart';

Entity createShipWreck({
  required Asset<Image> image,
  required Entity planet,
  required double angle,
}) {
  final entity = Entity();

  // position
  entity.add(Transform());

  entity.add(PlanetOccupant(planet: planet, angle: angle));

  // entity.add(
  //   ParticleEmitter(
  //     spawnRate: 50,
  //     maxLifetime: 5.0,
  //     minLifetime: 2.0,
  //     fadeOutTime: 2.0,
  //     colors: [Color.fromARGB(79, 142, 142, 142)],
  //     particleSize: Size.square(4),
  //     initialVelocity: Vector2(0, -25),
  //     turbulence: 1,
  //     mass: 0,
  //   ),
  // );

  // rendering
  entity.add(Sprite(image: image, z: 20));

  // cleanup
  entity.add(Parent(parent: planet));

  return entity;
}

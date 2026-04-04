import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/asteroid/asteroid_spawn_spec.dart';

Entity createAsteroid(AsteroidSpawnSpec spec) {
  final AsteroidSpawnSpec(:position, :rotation, :image, :variant, :parent) =
      spec;

  final entity = Entity();

  entity.add(Transform(position: position, rotation: rotation));
  entity.add(
    Sprite(
      image: image,
      sourceRect: Rect.fromLTWH(
        200.0 * (variant % 3),
        200.0 * (variant ~/ 3),
        200.0,
        200.0,
      ),
    ),
  );

  if (parent != null) {
    entity.add(Parent(parent: parent));
  }

  return entity;
}

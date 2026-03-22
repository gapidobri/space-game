import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/alien_tag.dart';

Entity createAlien({required Image image}) {
  final entity = Entity();

  // identity
  entity.add(AlienTag());

  // transform
  entity.add(Transform(scale: Vector2.all(2.0)));

  // physics
  entity.add(RigidBody());
  entity.add(CircleCollider(radius: 20));

  // rendering
  entity.add(Sprite(image: image, sourceRect: Rect.fromLTWH(50, 57, 29, 17)));

  return entity;
}

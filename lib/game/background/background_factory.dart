import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/background/parallax.dart';

Entity createBackground({
  required Asset<Image> image,
  double parallax = 0,
  Entity? parent,
}) {
  final entity = Entity();
  if (parent != null) {
    entity.add(Parent(parent: parent));
  }

  entity.add(Transform(scale: Vector2.all(2)));
  entity.add(
    TiledSprite(
      image: image,
      tileSize: Size(image.data.width.toDouble(), image.data.height.toDouble()),
      extendInfinitely: true,
      z: -500,
    ),
  );
  entity.add(Parallax(multiplier: parallax));

  return entity;
}

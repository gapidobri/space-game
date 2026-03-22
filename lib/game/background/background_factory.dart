import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/background/parallax.dart';

Entity createBackground({required Image image, double parallax = 0}) {
  final entity = Entity();

  entity.add(Transform(scale: Vector2.all(2)));
  entity.add(
    TiledSprite(
      image: image,
      tileSize: Size(image.width.toDouble(), image.height.toDouble()),
      areaSize: const Size(4096, 4096),
      z: -500,
    ),
  );
  entity.add(Parallax(multiplier: parallax));

  return entity;
}

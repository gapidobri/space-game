import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/background/parallax.dart';

class BackgroundBuilder {
  const BackgroundBuilder({required this.image, this.parallax = 0});

  final Image image;
  final double parallax;

  Entity build() {
    final entity = Entity();

    entity.add(Transform(scale: Vector2.all(3)));
    entity.add(Sprite(image: image, z: -500));
    entity.add(Parallax(multiplier: parallax));

    return entity;
  }
}

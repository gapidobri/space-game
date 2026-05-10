import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/astronaut/astronaut_location.dart';
import 'package:space_game/game/astronaut/astronaut_tag.dart';
import 'package:space_game/game/hud/offscreen_indicator/offscreen_indicator.dart';

Entity createAstronaut({
  required Asset<Image> image,
  required AstronautLocation location,
  Entity? parent,
}) {
  final entity = Entity();
  // identity
  entity.add(AstronautTag());

  // position
  entity.add(Transform()..scale.setFrom(Vector2.all(0.5)));

  // rendering
  entity.add(Sprite(image: image, z: 20));

  // gameplay
  entity.add(AstronautLocationStore(location: location));

  // ui
  entity.add(OffscreenIndicator());

  // cleanup
  if (parent != null) {
    entity.add(Parent(parent: parent));
  }

  return entity;
}

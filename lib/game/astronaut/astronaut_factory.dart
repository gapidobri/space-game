import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/astronaut/astronaut_location.dart';
import 'package:space_game/game/astronaut/astronaut_tag.dart';
import 'package:space_game/game/hud/offscreen_indicator/offscreen_indicator.dart';

Entity createAstronaut({
  required Image image,
  required AstronautLocation location,
  Entity? parent,
}) {
  final entity = Entity();
  // identity
  entity.add(AstronautTag());

  // position
  entity.add(Transform()..scale.setValues(2, 2));

  // rendering
  entity.add(
    Sprite(image: image, sourceRect: Rect.fromLTWH(50, 50, 30, 25), z: 20),
  );

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

import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/hud/offscreen_indicator/offscreen_indicator.dart';
import 'package:space_game/game/interaction/interaction_target.dart';
import 'package:space_game/game/mining/mineral_tag.dart';
import 'package:space_game/game/mining/resource_node.dart';
import 'package:space_game/game/planet/occupancy/planet_occupant.dart';

Entity createMineral({
  required Asset<Image> image,
  required Entity planet,
  required double planetAngle,
  required ResourceType resourceType,
  required double volume,
  Entity? parent,
}) {
  final entity = Entity();

  // identity
  entity.add(MineralTag());

  // position
  entity.add(Transform()..scale.setValues(2.0, 2.0));

  // rendering
  entity.add(Sprite(image: image));

  // gameplay
  entity.add(PlanetOccupant(planet: planet, angle: planetAngle));
  entity.add(InteractionTarget(interactionText: 'Mine'));
  entity.add(ResourceNode(remaining: volume, resourceType: resourceType));

  // ui
  entity.add(OffscreenIndicator(image: image));

  // cleanup
  if (parent != null) {
    entity.add(Parent(parent: parent));
  }

  return entity;
}

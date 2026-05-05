import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/hud/offscreen_indicator/offscreen_indicator.dart';
import 'package:space_game/game/interaction/interaction_target.dart';
import 'package:space_game/game/mining/mineral_tag.dart';
import 'package:space_game/game/mining/resource_node.dart';
import 'package:space_game/game/planet/occupancy/planet_occupant.dart';

Entity createMineral({
  required Entity planet,
  required double planetAngle,
  Entity? parent,
}) {
  final entity = Entity();

  // identity
  entity.add(MineralTag());

  // position
  entity.add(Transform());

  // rendering
  entity.add(
    CircleShape(radius: 10, paint: PaintConfig()..color = Color(0xFFFFFFFF)),
  );

  // gameplay
  entity.add(PlanetOccupant(planet: planet, angle: planetAngle));
  entity.add(InteractionTarget());
  entity.add(ResourceNode(remaining: 10, resourceType: ResourceType.health));

  // ui
  entity.add(OffscreenIndicator());

  // cleanup
  if (parent != null) {
    entity.add(Parent(parent: parent));
  }

  return entity;
}

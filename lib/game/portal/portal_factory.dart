import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/hud/offscreen_indicator/offscreen_indicator.dart';
import 'package:space_game/game/portal/portal_spawn_spec.dart';
import 'package:space_game/game/portal/portal_tag.dart';

Entity createPortal(PortalSpawnSpec spec) {
  final PortalSpawnSpec(:position, :parent) = spec;

  final entity = Entity();

  // identity
  entity.add(PortalTag());

  // transform
  entity.add(Transform()..position.setFrom(position));

  // rendering
  entity.add(
    CircleShape(radius: 50, paint: Paint()..color = Color(0xff333fff)),
  );

  // ui
  entity.add(OffscreenIndicator());

  // cleanup
  if (parent != null) {
    entity.add(Parent(parent: parent));
  }

  return entity;
}

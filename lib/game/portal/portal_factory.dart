import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/hud/offscreen_indicator/offscreen_indicator.dart';
import 'package:space_game/game/portal/portal_spawn_spec.dart';
import 'package:space_game/game/portal/portal_state.dart';
import 'package:space_game/game/portal/portal_tag.dart';

Entity createPortal({required PortalSpawnSpec spec, Entity? parent}) {
  final PortalSpawnSpec(:position) = spec;

  final entity = Entity();

  entity.add(PortalTag());
  entity.add(Transform()..position.setFrom(position));
  entity.add(
    CircleShape(radius: 50, paint: Paint()..color = Color(0xff333fff)),
  );
  entity.add(CircleCollider(radius: 50));
  entity.add(PortalState());
  entity.add(OffscreenIndicator());

  if (parent != null) {
    entity.add(Parent(parent: parent));
  }

  return entity;
}

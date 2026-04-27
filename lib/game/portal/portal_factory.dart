import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/hud/offscreen_indicator/offscreen_indicator.dart';
import 'package:space_game/game/portal/portal_spawn_spec.dart';
import 'package:space_game/game/portal/portal_state.dart';
import 'package:space_game/game/portal/portal_tag.dart';

Entity createPortal({
  required PortalSpawnSpec spec,
  required Image image,
  Entity? parent,
}) {
  final PortalSpawnSpec(:position) = spec;

  final entity = Entity();

  entity.add(PortalTag());
  entity.add(
    Transform()
      ..position.setFrom(position)
      ..scale.setFrom(Vector2.all(2)),
  );

  entity.add(Sprite(image: image));
  entity.add(
    AnimatedSprite(
      frameWidth: 100,
      frameHeight: 100,
      frameCount: 61,
      framesPerSecond: 30,
    ),
  );

  entity.add(CircleCollider(radius: 50));

  entity.add(PortalState());
  entity.add(OffscreenIndicator(enabled: false));

  if (parent != null) {
    entity.add(Parent(parent: parent));
  }

  return entity;
}

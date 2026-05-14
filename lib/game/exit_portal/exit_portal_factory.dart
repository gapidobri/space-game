import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/hud/offscreen_indicator/offscreen_indicator.dart';
import 'package:space_game/game/exit_portal/exit_portal_spawn_spec.dart';
import 'package:space_game/game/exit_portal/exit_portal_state.dart';
import 'package:space_game/game/exit_portal/exit_portal_tag.dart';

Entity createExitPortal({
  required ExitPortalSpawnSpec spec,
  required Asset<Image> image,
  required Asset<Image> offscreenIndicatorImage,
  Entity? parent,
}) {
  final ExitPortalSpawnSpec(:position) = spec;

  final entity = Entity();

  entity.add(ExitPortalTag());
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

  entity.add(ExitPortalState());
  entity.add(
    OffscreenIndicator(
      enabled: false,
      image: offscreenIndicatorImage,
      scale: 0.5,
    ),
  );

  if (parent != null) {
    entity.add(Parent(parent: parent));
  }

  return entity;
}

import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/entry_portal/entry_portal_spawn_spec.dart';
import 'package:space_game/game/entry_portal/entry_portal_state.dart';
import 'package:space_game/game/entry_portal/entry_portal_tag.dart';

Entity createEntryPortal({
  required EntryPortalSpawnSpec spec,
  required Asset<Image> image,
  Entity? parent,
}) {
  final entity = Entity();

  entity.add(EntryPortalTag());
  entity.add(EntryPortalState());

  entity.add(
    Transform()
      ..position.setFrom(spec.position)
      ..scale.setFrom(Vector2.all(2.0)),
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

  if (parent != null) {
    entity.add(Parent(parent: parent));
  }

  return entity;
}

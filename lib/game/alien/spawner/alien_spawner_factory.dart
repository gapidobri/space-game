import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/spawner/alien_spawner.dart';
import 'package:space_game/game/alien/alien_type.dart';

Entity createAlienSpawner({required AlienType type, Entity? parent}) {
  final entity = Entity();

  entity.add(AlienSpawner(type: type));

  if (parent != null) {
    entity.add(Parent(parent: parent));
  }

  return entity;
}

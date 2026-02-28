import 'package:gamengine/src/ecs/component.dart';
import 'package:gamengine/src/ecs/entity.dart';

class World {
  final List<Entity> _entities = <Entity>[];

  Iterable<Entity> get entities => _entities;

  void addEntity(Entity entity) {
    _entities.add(entity);
  }

  void removeEntity(Entity entity) {
    _entities.remove(entity);
  }

  T get<T extends Component>(Entity entity) {
    return entity.get<T>() as T;
  }

  Iterable<Entity> query2<T1 extends Component, T2 extends Component>() sync* {
    for (final entity in _entities) {
      if (entity.get<T1>() != null && entity.get<T2>() != null) {
        yield entity;
      }
    }
  }
}

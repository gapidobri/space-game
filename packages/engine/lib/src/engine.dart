import 'package:gamengine/src/entity.dart';
import 'package:gamengine/src/node.dart';
import 'package:gamengine/src/system.dart';

class Engine {
  final _entities = <Entity>[];
  final _systems = <System>[];
  final _nodeLists = <Type, List<Node>>{};

  void addEntity(Entity entity) {
    _entities.add(entity);
  }

  void removeEntity(Entity entity) {
    _entities.remove(entity);
  }

  void addSystem(System system, int priority) {
    _systems.add(system);
    _systems.sort((a, b) => b.priority.compareTo(a.priority));
    system.start();
  }

  void removeSystem(System system) {
    system.end();
    _systems.remove(system);
  }

  List<T> getNodeList<T extends Node>() {
    final nodes = <T>[];
    _nodeLists[T] = nodes;

    // TODO: populate

    return nodes;
  }

  void update(double dt) {
    for (final system in _systems) {
      system.update(dt);
    }
  }
}

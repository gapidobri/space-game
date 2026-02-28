import 'package:gamengine/src/ecs/entity.dart';
import 'package:gamengine/src/ecs/system.dart';
import 'package:gamengine/src/ecs/world.dart';

class Engine {
  final World world;
  final _systems = <System>[];

  Engine({World? world}) : world = world ?? World();

  void addEntity(Entity entity) {
    world.addEntity(entity);
  }

  void removeEntity(Entity entity) {
    world.removeEntity(entity);
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

  void update(double dt) {
    for (final system in _systems) {
      system.update(dt);
    }
  }
}

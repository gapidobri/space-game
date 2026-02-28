import 'package:gamengine/src/component.dart';

class Entity {
  final _components = <Type, Component>{};

  void add(Component component) {
    _components[component.runtimeType] = component;
  }

  void remove(Type componentType) {
    _components.remove(componentType);
  }

  Component? get<T extends Component>() {
    return _components[T];
  }
}

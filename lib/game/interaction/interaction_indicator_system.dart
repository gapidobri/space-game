import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/interaction/interactable.dart';

class _InteractionIndicatorRef extends Component {
  _InteractionIndicatorRef(this.identicator);

  final Entity identicator;
}

class InteractionIndicatorSystem extends System {
  InteractionIndicatorSystem({super.priority});

  @override
  void update(double dt, World world, Commands commands) {
    for (final entity in world.query<Interactable>()) {
      var idRef = entity.tryGet<_InteractionIndicatorRef>();

      if (idRef == null) {
        final identicator = Entity();
        identicator.add(Transform());
        identicator.add(
          CircleShape(
            radius: 100, // TODO: get from Eva
            paint: Paint()
              ..color = Color.fromARGB(100, 100, 255, 100)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3.0,
            z: 100,
          ),
        );

        idRef = _InteractionIndicatorRef(identicator);
        entity.add(idRef);

        commands.spawn(identicator);
      }

      final identicator = idRef.identicator;

      final transform = entity.get<Transform>();
      final idTransform = identicator.get<Transform>();

      idTransform.position.setFrom(transform.position);
    }

    for (final entity in world.query<_InteractionIndicatorRef>()) {
      if (entity.has<Interactable>()) continue;

      final ref = entity.get<_InteractionIndicatorRef>();
      commands.removeComponent<_InteractionIndicatorRef>(entity);
      commands.despawn(ref.identicator);
    }
  }
}

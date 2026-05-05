import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/interaction/interaction_target.dart';
import 'package:space_game/game/rocket/components/eva.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';

class InteractionIndicatorRef extends Component {
  InteractionIndicatorRef(this.indicator);

  final Entity indicator;
}

class InteractionIndicatorSystem extends System {
  InteractionIndicatorSystem({super.priority});

  @override
  void update(double dt, World world, Commands commands) {
    final rocket = world.query<RocketTag>().firstOrNull;
    if (rocket == null) return;

    final eva = rocket.get<Eva>();

    for (final entity in world.query<InteractionTarget>()) {
      var idRef = entity.tryGet<InteractionIndicatorRef>();

      if (idRef == null) {
        final identicator = Entity();
        identicator.add(Parent(parent: entity));
        identicator.add(Transform());
        identicator.add(
          CircleShape(
            radius: eva.maxInteractionRange,
            paint: PaintConfig()
              ..color = Color.fromARGB(100, 100, 255, 100)
              ..style = PaintingStyle.stroke
              ..strokeWidth = 3.0,
            z: 100,
          ),
        );

        idRef = InteractionIndicatorRef(identicator);
        entity.add(idRef);

        commands.spawn(identicator);
      }

      final identicator = idRef.indicator;

      final transform = entity.get<Transform>();
      final idTransform = identicator.get<Transform>();
      final circleShape = identicator.get<CircleShape>();

      circleShape.radius = eva.maxInteractionRange;

      idTransform.position.setFrom(transform.position);
    }

    // cleanup
    for (final entity in world.query<InteractionIndicatorRef>()) {
      if (entity.has<InteractionTarget>()) continue;

      final ref = entity.get<InteractionIndicatorRef>();
      commands.removeComponent<InteractionIndicatorRef>(entity);
      commands.despawn(ref.indicator);
    }
  }
}

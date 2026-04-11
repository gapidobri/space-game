import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/portal/portal_state.dart';
import 'package:space_game/game/portal/portal_tag.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';
import 'package:space_game/game/stage/components/stage_state.dart';

class PortalSystem extends System {
  PortalSystem({super.priority, required this.eventBus});

  final EventBus eventBus;

  @override
  void update(double dt, World world, Commands commands) {
    final rocket = world.query<RocketTag>().firstOrNull;
    if (rocket == null) return;

    final portal = world.query<PortalTag>().firstOrNull;
    if (portal == null) return;

    final state = portal.get<PortalState>();

    final stageState = world.tryGetComponent<StageState>();
    if (stageState == null) return;
    if (stageState.phase == .portalReady) {
      state.status = .activated;
    }

    if (state.status == .activated) {
      for (final event in eventBus.read<CollisionEvent>()) {
        if (event.entities.contains(rocket) &&
            event.entities.contains(portal)) {
          state.status = .teleporting;
        }
      }
    }

    final circleShape = portal.get<CircleShape>();

    switch (state.status) {
      case .closed:
        circleShape.paint?.color = Color.fromARGB(255, 69, 69, 69);
        break;
      case .activated:
        circleShape.paint?.color = Color.fromARGB(255, 12, 103, 201);
        break;
      case .teleporting || .completed:
        circleShape.paint?.color = Color.fromARGB(255, 93, 213, 89);
        break;
    }
  }
}

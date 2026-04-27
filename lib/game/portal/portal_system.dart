import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/hud/offscreen_indicator/offscreen_indicator.dart';
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
    final indicator = portal.get<OffscreenIndicator>();

    final stageState = world.tryGetComponent<StageState>();
    if (stageState == null) return;
    if (state.status == .closed && stageState.phase == .portalReady) {
      state.status = .opening;
    }

    if (state.status == .open) {
      for (final event in eventBus.read<CollisionEvent>()) {
        if (event.entities.contains(rocket) &&
            event.entities.contains(portal)) {
          state.status = .teleporting;
        }
      }
    }

    indicator.enabled = state.status != .closed;
  }
}

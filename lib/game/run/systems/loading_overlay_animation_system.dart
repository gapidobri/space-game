import 'package:gamengine/ecs.dart';
import 'package:space_game/game/run/components/loading_overlay_state.dart';
import 'package:space_game/game/run/components/run_state.dart';
import 'package:space_game/game/run/run_tag.dart';

const _duration = 3;

class LoadingOverlayAnimationSystem extends System {
  @override
  void update(double dt, World world, Commands commands) {
    for (final run in world.query<RunTag>()) {
      final runState = run.get<RunState>();
      final overlayState = run.get<LoadingOverlayState>();
      final showOverlay = switch (runState.phase) {
        .runStart || .stageTransition || .stageExit => true,
        _ => false,
      };

      if (showOverlay && overlayState.opacity < 1.0) {
        overlayState.opacity += dt / _duration;
        if (overlayState.opacity > 1.0) {
          overlayState.opacity = 1.0;
        }
        return;
      }

      if (!showOverlay && overlayState.opacity > 0.0) {
        overlayState.opacity -= dt / _duration;
        if (overlayState.opacity < 0.0) {
          overlayState.opacity = 0.0;
        }
      }
    }
  }
}

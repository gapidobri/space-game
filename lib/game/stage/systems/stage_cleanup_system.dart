import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/run/components/run_state.dart';
import 'package:space_game/game/stage/components/stage_state.dart';

class StageCleanupSystem extends System {
  @override
  void update(double dt, World world, Commands commands) {
    final runState = world.tryGetComponent<RunState>();
    if (runState == null || runState.phase != .stageTransition) return;

    for (final stage in world.query<StageState>()) {
      commands.despawn(stage);
    }
  }
}

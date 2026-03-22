import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/run/components/current_stage.dart';
import 'package:space_game/game/run/components/run_state.dart';
import 'package:space_game/game/run/run_tag.dart';

class StageCleanupSystem extends System {
  @override
  void update(double dt, World world, Commands commands) {
    final run = world.query<RunTag>().firstOrNull;
    if (run == null) return;

    final runState = run.get<RunState>();
    if (runState.phase != .stageTransition) return;

    final currentStage = run.get<CurrentStage>();
    final stage = currentStage.stage;
    if (stage == null) return;

    currentStage.stage = null;
    commands.despawn(stage);
  }
}

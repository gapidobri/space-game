import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/run/components/run_state.dart';
import 'package:space_game/game/run/events/run_phase_changed_event.dart';
import 'package:space_game/game/stage/components/stage_setup_state.dart';

class RunFlowSystem extends System {
  RunFlowSystem({super.priority, required this.eventBus});

  final EventBus eventBus;

  @override
  void update(double dt, World world, Commands commands) {
    final runState = world.tryGetComponent<RunState>();
    if (runState == null) return;

    switch (runState.phase) {
      case .runStart: // -> stageEnter
        // setup player state
        _changePhase(runState, .stageEnter);
        break;

      case .stageEnter: // -> stagePlay, finalBoss
        final stageSetupState = world.tryGetComponent<StageSetupState>();
        if (stageSetupState == null || stageSetupState.status != .ready) {
          break;
        }
        _changePhase(runState, .stagePlay);
        break;

      case .stagePlay: // -> stageExit, runFailed
        // normal gameplay
        // TODO: wait for exit conditions
        break;

      case .stageExit: // -> stageTransition
        // rewards
        _changePhase(runState, .stageTransition);
        break;

      case .stageTransition: // -> stageEnter
        // cleanup, increase difficulty
        _changePhase(runState, .stageEnter);
        break;

      case .finalBoss: // -> runComplete, runFailed
        // special final boss stage
        // TODO: wait for win/loose conditions
        _changePhase(runState, .runComplete);
        break;

      case .runComplete: // -> runStart
        // show win + stats
        break;

      case .runFailed: // -> runStart
        // show game over
        break;
    }
  }

  void _changePhase(RunState runState, RunPhase phase) {
    eventBus.emit(RunPhaseChangedEvent(from: runState.phase, to: phase));
    runState.phase = phase;
  }
}

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/rocket/events/rocket_destroyed_event.dart';
import 'package:space_game/game/run/components/current_stage.dart';
import 'package:space_game/game/run/components/loading_overlay_state.dart';
import 'package:space_game/game/run/components/run_state.dart';
import 'package:space_game/game/run/events/run_phase_changed_event.dart';
import 'package:space_game/game/run/run_tag.dart';
import 'package:space_game/game/stage/components/stage_setup_state.dart';
import 'package:space_game/game/stage/components/stage_state.dart';
import 'package:space_game/game/stage/components/stage_transition_state.dart';

class RunFlowSystem extends System {
  RunFlowSystem({super.priority, required this.eventBus});

  final EventBus eventBus;

  @override
  void update(double dt, World world, Commands commands) {
    final run = world.query<RunTag>().firstOrNull;
    if (run == null) return;

    final runState = run.get<RunState>();

    final stage = run.get<CurrentStage>().stage;

    switch (runState.phase) {
      case .runStart: // -> stageEnter
        // setup player state
        _changePhase(runState, .stageSetup);
        break;

      // Generate stage
      case .stageSetup: // -> stagePlay, finalBoss
        if (stage == null ||
            stage.get<StageSetupState>().status != .ready ||
            !stage.get<StageTransitionState>().playerPlaced) {
          break;
        }
        _changePhase(runState, .stageEnter);
        break;

      // Fade out loading overlay
      case .stageEnter:
        final loadingOverlayState = run.get<LoadingOverlayState>();
        if (loadingOverlayState.opacity > 0) break;

        _changePhase(runState, .stagePlay);
        break;

      // Gameplay
      case .stagePlay: // -> stageExit, runFailed
        if (stage?.get<StageState>().phase == .leaving) {
          _changePhase(runState, .stageExit);
          break;
        }
        if (eventBus.read<RocketDestroyedEvent>().isNotEmpty) {
          _changePhase(runState, .runFailed);
          break;
        }
        break;

      case .stageExit: // -> stageTransition
        // rewards
        _changePhase(runState, .stageTransition);
        break;

      case .stageTransition: // -> stageSetup
        // cleanup, increase difficulty
        runState.stageIndex++;
        _changePhase(runState, .stageSetup);
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

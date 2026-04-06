import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/objective/components/objective.dart';
import 'package:space_game/game/portal/portal_state.dart';
import 'package:space_game/game/stage/components/stage_setup_state.dart';
import 'package:space_game/game/stage/components/stage_state.dart';
import 'package:space_game/game/stage/events/stage_phase_changed_event.dart';
import 'package:space_game/game/stage/stage_tag.dart';

class StageFlowSystem extends System {
  StageFlowSystem({super.priority, required this.eventBus});

  final EventBus eventBus;

  @override
  void update(double dt, World world, Commands commands) {
    for (final stage in world.query<StageTag>()) {
      final state = stage.get<StageState>();

      final setupStatus = stage.get<StageSetupState>().status;
      if (setupStatus != .ready) continue;

      switch (state.phase) {
        case .briefing:
          // TODO: implement
          _changePhase(state, .exploring);
          break;

        case .exploring:
          final objectives = world.query<Objective>();
          if (objectives.every((o) => o.get<Objective>().completed)) {
            _changePhase(state, .portalReady);
          }
          break;

        case .portalReady:
          final portalState = world.tryGetComponent<PortalState>();
          if (portalState?.status == .teleporting) {
            _changePhase(state, .portalActivating);
          }
          break;

        case .portalActivating:
          _changePhase(state, .leaving);
          break;

        case .leaving:
          break;
      }
    }
  }

  void _changePhase(StageState stageState, StagePhase phase) {
    eventBus.emit(StagePhaseChangedEvent(from: stageState.phase, to: phase));
    stageState.phase = phase;
  }
}

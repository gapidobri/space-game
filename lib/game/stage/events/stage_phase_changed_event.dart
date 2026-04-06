import 'package:gamengine/ecs.dart';
import 'package:space_game/game/stage/components/stage_state.dart';

class StagePhaseChangedEvent extends GameEvent {
  const StagePhaseChangedEvent({required this.from, required this.to});

  final StagePhase from;
  final StagePhase to;
}

import 'package:gamengine/ecs.dart';
import 'package:space_game/game/run/components/run_state.dart';

class RunPhaseChangedEvent extends GameEvent {
  const RunPhaseChangedEvent({required this.from, required this.to});

  final RunPhase from;
  final RunPhase to;
}

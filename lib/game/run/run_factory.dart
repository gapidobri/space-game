import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/run/components/difficulty_state.dart';
import 'package:space_game/game/run/components/run_state.dart';

Entity createRun() {
  final entity = Entity();

  entity.add(RunState(phase: RunPhase.runStart));
  entity.add(DifficultyState());

  return entity;
}

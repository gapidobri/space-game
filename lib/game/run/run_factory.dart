import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/run/components/current_stage.dart';
import 'package:space_game/game/run/components/difficulty_state.dart';
import 'package:space_game/game/run/components/run_state.dart';
import 'package:space_game/game/run/run_tag.dart';

Entity createRun() {
  final entity = Entity();

  entity.add(RunTag());

  entity.add(CurrentStage());
  entity.add(RunState(phase: RunPhase.runStart));
  entity.add(DifficultyState());

  return entity;
}

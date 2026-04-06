import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/stage/components/stage_setup_state.dart';
import 'package:space_game/game/stage/components/stage_state.dart';
import 'package:space_game/game/stage/components/stage_transition_state.dart';
import 'package:space_game/game/stage/stage_tag.dart';

Entity createStage({Entity? parent}) {
  final entity = Entity();
  entity.add(StageTag());

  entity.add(StageSetupState());
  entity.add(StageTransitionState());

  entity.add(StageState(phase: StagePhase.briefing));

  if (parent != null) {
    entity.add(Parent(parent: parent));
  }

  return entity;
}

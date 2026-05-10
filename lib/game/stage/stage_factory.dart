import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/sound/background_music/background_music.dart';
import 'package:space_game/game/stage/components/stage_setup_state.dart';
import 'package:space_game/game/stage/components/stage_state.dart';
import 'package:space_game/game/stage/components/stage_transition_state.dart';
import 'package:space_game/game/stage/stage_tag.dart';

Entity createStage({required String backgroundMusic, Entity? parent}) {
  final entity = Entity();
  entity.add(StageTag());

  entity.add(StageSetupState());
  entity.add(StageTransitionState());

  entity.add(StageState(phase: StagePhase.briefing));

  entity.add(BackgroundMusic(assetPath: backgroundMusic, fadeTime: 2));

  if (parent != null) {
    entity.add(Parent(parent: parent));
  }

  return entity;
}

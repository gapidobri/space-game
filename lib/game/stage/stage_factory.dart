import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/stage/components/stage_setup_state.dart';
import 'package:space_game/game/stage/components/stage_state.dart';
import 'package:space_game/game/stage/components/teleporter_state.dart';

Entity createStage({required int requiredTeleporterParts}) {
  final entity = Entity();

  entity.add(StageSetupState());

  entity.add(StageState(phase: StagePhase.briefing));
  entity.add(TeleporterState(requiredParts: requiredTeleporterParts));

  return entity;
}

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/objective/components/objective.dart';

Entity createObjective({
  required ObjectiveKind kind,
  required ObjectiveTier tier,
}) {
  final entity = Entity();

  entity.add(Objective(kind: kind, tier: tier));

  return entity;
}

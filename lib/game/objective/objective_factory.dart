import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/objective/components/objective.dart';
import 'package:space_game/game/objective/components/rescue_objective_data.dart';

Entity createObjective({
  required ObjectiveKind kind,
  required ObjectiveTier tier,
  Entity? astronaut,
  Entity? parent,
}) {
  final entity = Entity();

  entity.add(Objective(kind: kind, tier: tier));

  switch (kind) {
    case .mine:
      break;
    case .rescue:
      assert(astronaut != null, 'Astronaut should not be null');
      entity.add(RescueObjectiveData(astronaut: astronaut!));
      break;
  }

  if (parent != null) {
    entity.add(Parent(parent: parent));
  }

  return entity;
}

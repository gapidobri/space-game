import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/astronaut/astronaut_location.dart';
import 'package:space_game/game/objective/components/objective.dart';
import 'package:space_game/game/objective/components/rescue_objective_data.dart';
import 'package:space_game/game/objective/events/objective_completed_event.dart';

class ObjectiveSystem extends System {
  ObjectiveSystem({super.priority, required this.eventBus});

  final EventBus eventBus;

  @override
  void update(double dt, World world, Commands commands) {
    for (final entity in world.query<Objective>()) {
      final objective = entity.get<Objective>();
      if (objective.completed) continue;

      switch (objective.kind) {
        case .mine:
          _checkMineObjective(entity);
          break;
        case .rescue:
          _checkRecueObjective(entity, objective);
          break;
      }

      if (objective.completed) {
        eventBus.emit(ObjectiveCompletedEvent(objective: entity));
      }
    }
  }

  void _checkMineObjective(Entity entity) {
    // TODO: implement check
  }

  void _checkRecueObjective(Entity entity, Objective objective) {
    final data = entity.tryGet<RescueObjectiveData>();
    if (data == null) return;

    final store = data.astronaut.get<AstronautLocationStore>();
    if (store.location is AstronautLocationInRocket) {
      objective.completed = true;
    }
  }
}

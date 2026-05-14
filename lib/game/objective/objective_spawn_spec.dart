import 'package:space_game/game/astronaut/astronaut_spawn_spec.dart';
import 'package:space_game/game/mining/mineral_spawn_spec.dart';
import 'package:space_game/game/objective/components/objective.dart';

class ObjectiveSpawnSpec {
  const ObjectiveSpawnSpec({
    required this.kind,
    required this.tier,
    this.astronaut,
    this.mineral,
  });

  final ObjectiveKind kind;
  final ObjectiveTier tier;
  final AstronautSpawnSpec? astronaut;
  final MineralSpawnSpec? mineral;
}

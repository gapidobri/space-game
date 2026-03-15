import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/interaction/interactable.dart';
import 'package:space_game/game/mining/minable.dart';
import 'package:space_game/game/planet/occupancy/planet_occupant.dart';

class MineralTag extends Component {}

class MineralBuilder {
  const MineralBuilder({required this.planet, required this.planetAngle});

  final Entity planet;
  final double planetAngle;

  Entity build() {
    final entity = Entity();
    entity.add(MineralTag());

    entity.add(Transform());
    entity.add(
      CircleShape(radius: 10, paint: Paint()..color = Color(0xFFFFFFFF)),
    );
    entity.add(PlanetOccupant(planet: planet, angle: planetAngle));

    entity.add(Interactable());
    entity.add(Minable(remaining: 10, resourceType: ResourceType.health));

    return entity;
  }
}

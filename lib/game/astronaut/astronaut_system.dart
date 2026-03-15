import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/astronaut/astronaut.dart';
import 'package:space_game/game/astronaut/astronaut_location.dart';
import 'package:space_game/game/interaction/interactable.dart';
import 'package:space_game/game/planet/occupancy/planet_occupant.dart';

class AstronautSystem extends System {
  AstronautSystem({super.priority});

  @override
  void update(double dt, World world, Commands commands) {
    for (final astronaut in world.query<AstronautTag>()) {
      final location = astronaut.get<AstronautLocationStore>();
      final sprite = astronaut.get<Sprite>();

      final locationType = location.location;

      switch (locationType) {
        case AstronautLocationOnPlanet(:final planet, :final angle):
          sprite.visible = true;
          if (!astronaut.has<Interactable>()) {
            commands.addComponent<Interactable>(astronaut, Interactable());
          }
          if (!astronaut.has<PlanetOccupant>()) {
            commands.addComponent<PlanetOccupant>(
              astronaut,
              PlanetOccupant(planet: planet, angle: angle),
            );
          }
          break;

        case AstronautLocationInRocket():
          sprite.visible = false;
          if (astronaut.has<Interactable>()) {
            commands.removeComponent<Interactable>(astronaut);
          }
          if (astronaut.has<PlanetOccupant>()) {
            commands.removeComponent<PlanetOccupant>(astronaut);
          }
          break;
      }
    }
  }
}

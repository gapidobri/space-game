import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/astronaut/astronaut_tag.dart';
import 'package:space_game/game/astronaut/astronaut_location.dart';
import 'package:space_game/game/hud/offscreen_indicator/offscreen_indicator.dart';
import 'package:space_game/game/interaction/interaction_target.dart';
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
          if (!astronaut.has<InteractionTarget>()) {
            commands.addComponent<InteractionTarget>(
              astronaut,
              InteractionTarget(),
            );
          }
          if (!astronaut.has<PlanetOccupant>()) {
            commands.addComponent<PlanetOccupant>(
              astronaut,
              PlanetOccupant(planet: planet, angle: angle),
            );
          }
          if (!astronaut.has<OffscreenIndicator>()) {
            commands.addComponent<OffscreenIndicator>(
              astronaut,
              OffscreenIndicator(),
            );
          }
          break;

        case AstronautLocationInRocket():
          sprite.visible = false;
          if (astronaut.has<InteractionTarget>()) {
            commands.removeComponent<InteractionTarget>(astronaut);
          }
          if (astronaut.has<PlanetOccupant>()) {
            commands.removeComponent<PlanetOccupant>(astronaut);
          }
          if (astronaut.has<OffscreenIndicator>()) {
            commands.removeComponent<OffscreenIndicator>(astronaut);
          }
          break;
      }
    }
  }
}

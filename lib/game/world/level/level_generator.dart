import 'dart:math' as math;
import 'dart:ui';

import 'package:space_game/game/astronaut/astronaut_factory.dart';
import 'package:space_game/game/astronaut/astronaut_location.dart';
import 'package:space_game/game/background/background_factory.dart';
import 'package:space_game/game/app/game_session.dart';
import 'package:space_game/game/mining/mineral_factory.dart';
import 'package:space_game/game/planet/atmosphere/atmosphere_config.dart';
import 'package:space_game/game/planet/planet_factory.dart';
import 'package:space_game/game/world/level/level_config.dart';

Future<void> generateLevel({
  required GameSession session,
  required LevelConfig levelConfig,
}) async {
  final GameSession(:engine, :assetManager) = session;

  engine.addEntity(
    createBackground(
      image: await assetManager.loadImage(
        'assets/background/background_dust.png',
      ),
      parallax: 0.9,
    ),
  );
  engine.addEntity(
    createBackground(
      image: await assetManager.loadImage(
        'assets/background/background_stars.png',
      ),
      parallax: 0.89,
    ),
  );

  final planet = createPlanet(
    image: await assetManager.loadImage('assets/planets/planet_03.png'),
    mass: 6e16,
    atmosphere: AtmosphereConfig(
      radius: 500,
      color: Color.fromARGB(50, 255, 100, 100),
      drag: 10,
      fuelRichness: 2,
    ),
  );
  engine.addEntity(planet);

  engine.addEntity(
    createAstronaut(
      image: await assetManager.loadImage('assets/atlas.png'),
      location: AstronautLocationOnPlanet(
        planet: planet,
        angle: math.Random().nextDouble() * 2 * math.pi,
      ),
    ),
  );

  engine.addEntity(createMineral(planet: planet, planetAngle: -math.pi / 2));
}

import 'dart:math' as math;

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/background/background_factory.dart';
import 'package:space_game/game/portal/portal_factory.dart';
import 'package:space_game/game/stage/components/stage_spawn_point.dart';
import 'package:space_game/game/stage/stage_config.dart';
import 'package:space_game/game/utils.dart';

Future<void> generateStage({
  required Commands commands,
  required AssetManager assetManager,
  required StageConfig stageConfig,
  required Entity stage,
}) async {
  final StageConfig(:stageSize) = stageConfig;

  final random = math.Random();

  final playerSpawnPadding = 500.0;
  final portalSpawnDistance = 5000.0;

  final playerSpawnPosition = Vector2(
    (stageSize.x - 2 * playerSpawnPadding) * random.nextDouble() +
        playerSpawnPadding,
    (stageSize.y - 2 * playerSpawnPadding) * random.nextDouble() +
        playerSpawnPadding,
  );
  commands.addComponent(
    stage,
    StageSpawnPoint(playerPosition: playerSpawnPosition),
  );

  late Vector2 portalSpawnPosition;
  do {
    final portalSpawnAngle = 2 * math.pi * random.nextDouble();
    final portalSpawnVector = Vector2(
      math.cos(portalSpawnAngle),
      math.sin(portalSpawnAngle),
    );
    portalSpawnPosition = portalSpawnVector * portalSpawnDistance;
  } while (!stageSize.rect.contains(portalSpawnPosition.offset));

  commands.spawn(createPortal(position: portalSpawnPosition, parent: stage));

  commands.spawn(
    createBackground(
      image: await assetManager.loadImage(
        'assets/background/background_dust.png',
      ),
      parallax: 0.9,
      parent: stage,
    ),
  );
  commands.spawn(
    createBackground(
      image: await assetManager.loadImage(
        'assets/background/background_stars.png',
      ),
      parallax: 0.89,
      parent: stage,
    ),
  );

  // final planet = createPlanet(
  //   image: await assetManager.loadImage('assets/planets/planet_03.png'),
  //   mass: 6e16,
  //   position: Vector2(0, 500),
  //   atmosphere: AtmosphereConfig(
  //     radius: 500,
  //     color: Color.fromARGB(50, 255, 100, 100),
  //     drag: 10,
  //     fuelRichness: 2,
  //   ),
  //   parent: parent,
  // );
  // commands.spawn(planet);

  // commands.spawn(
  //   createAstronaut(
  //     image: await assetManager.loadImage('assets/atlas.png'),
  //     location: AstronautLocationOnPlanet(
  //       planet: planet,
  //       angle: math.Random().nextDouble() * 2 * math.pi,
  //     ),
  //     parent: parent,
  //   ),
  // );

  // commands.spawn(
  //   createMineral(planet: planet, planetAngle: -math.pi / 2, parent: parent),
  // );
}

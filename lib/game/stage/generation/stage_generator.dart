import 'dart:math';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/asteroid/asteroid_spawn_spec.dart';
import 'package:space_game/game/entry_portal/entry_portal_spawn_spec.dart';
import 'package:space_game/game/planet/planet_spawn_spec.dart';
import 'package:space_game/game/exit_portal/exit_portal_spawn_spec.dart';
import 'package:space_game/game/stage/generation/stage_spawnpoint_spec.dart';
import 'package:space_game/game/stage/stage_blueprint.dart';
import 'package:space_game/game/stage/stage_config.dart';

const playerSpawnPadding = 500.0;
const minPlayerDistance = 200.0;
const portalSpawnDistance = 5000.0;
const minPlanetDistance = 500.0;

class StageGenerator {
  StageGenerator({
    required this.assetManager,
    required this.stageConfig,
    required this.stage,
    required this.random,
  });

  final AssetManager assetManager;
  final StageConfig stageConfig;
  final Entity stage;
  final Random random;

  final blueprint = StageBlueprint();

  StageBlueprint generate() {
    final StageConfig(:stageSize, :regionPlanetCount) = stageConfig;

    // player
    final playerSpawnPosition = Vector2(
      (stageSize.x - 2 * playerSpawnPadding) * random.nextDouble() +
          playerSpawnPadding,
      (stageSize.y - 2 * playerSpawnPadding) * random.nextDouble() +
          playerSpawnPadding,
    );
    blueprint.spawnPoint = StageSpawnpointSpec(
      position: playerSpawnPosition,
      spawnAreaRadius: minPlanetDistance,
    );
    blueprint.entryPortal = EntryPortalSpawnSpec(position: playerSpawnPosition);

    // regions
    final leftBottomDistance = stageSize - playerSpawnPosition;
    final maxEdgeDistance = max(
      max(playerSpawnPosition.x, leftBottomDistance.x),
      max(playerSpawnPosition.y, leftBottomDistance.y),
    );

    final regionFractions = [0, 0.25, 0.5, 0.75, 1.0];
    final regionDistances = regionFractions
        .map((f) => maxEdgeDistance * f)
        .toList();

    // portal
    late Vector2 portalSpawnPosition;
    do {
      final portalSpawnAngle = 2 * pi * random.nextDouble();
      final portalSpawnVector = Vector2(
        cos(portalSpawnAngle),
        sin(portalSpawnAngle),
      ).normalized();
      portalSpawnPosition =
          playerSpawnPosition + portalSpawnVector * portalSpawnDistance;
    } while (!stageSize.toRect().contains(portalSpawnPosition.toOffset()));

    blueprint.portal = ExitPortalSpawnSpec(position: portalSpawnPosition);

    // planets
    for (int i = 0; i < regionDistances.length - 1; i++) {
      final min = regionDistances[i];
      final max = regionDistances[i + 1];

      for (int j = 0; j < regionPlanetCount; j++) {
        final position = _getRandomPosition(
          center: playerSpawnPosition,
          min: min,
          max: max,
          radius: 300,
        );
        if (position == null) continue;

        blueprint.planets.add(
          PlanetSpawnSpec(
            image: assetManager.image(
              'assets/planets/planet_0${random.nextInt(7) + 1}.png',
            )!,
            radius: 300,
            mass: 6e16,
            position: position,
            canHostAstronaut: true, // TODO: check planet type
          ),
        );
      }
    }

    // asteroids
    final asteroidsImage = assetManager.image('assets/asteroids.png')!;
    for (int i = 0; i < regionDistances.length - 1; i++) {
      final min = regionDistances[i];
      final max = regionDistances[i + 1];

      for (int j = 0; j < 10; j++) {
        final position = _getRandomPosition(
          center: playerSpawnPosition,
          min: min,
          max: max,
          radius: 100,
        );
        if (position == null) continue;

        blueprint.asteroids.add(
          AsteroidSpawnSpec(
            image: asteroidsImage,
            position: position,
            rotation: random.nextDouble() * 2 * pi,
            variant: random.nextInt(9),
          ),
        );
      }
    }

    return blueprint;
  }

  Vector2? _getRandomPosition({
    required Vector2 center,
    required double min,
    required double max,
    double radius = 0,
  }) {
    int count = 0;
    late Vector2 position;
    do {
      final angle = 2 * pi * random.nextDouble();
      final vector = Vector2(cos(angle), sin(angle));
      final distance = (max - min) * random.nextDouble() + min;
      position = center + vector * distance;
      count++;
      if (count > 100000) {
        return null;
      }
    } while (!stageConfig.stageSize.toRect().contains(position.toOffset()) ||
        blueprint.occupied.any(
          (footprint) =>
              footprint.position.distanceTo(position) <
              footprint.radius + radius + minPlanetDistance,
        ));
    return position;
  }
}

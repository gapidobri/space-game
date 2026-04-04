import 'dart:math' as math;
import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/asteroid/asteroid_factory.dart';
import 'package:space_game/game/asteroid/asteroid_spawn_spec.dart';
import 'package:space_game/game/background/background_factory.dart';
import 'package:space_game/game/planet/planet_factory.dart';
import 'package:space_game/game/planet/planet_spawn_spec.dart';
import 'package:space_game/game/portal/portal_factory.dart';
import 'package:space_game/game/portal/portal_spawn_spec.dart';
import 'package:space_game/game/stage/components/stage_spawn_point.dart';
import 'package:space_game/game/stage/generation/spawn_footprint.dart';
import 'package:space_game/game/stage/stage_blueprint.dart';
import 'package:space_game/game/stage/stage_config.dart';
import 'package:space_game/game/utils.dart';

const playerSpawnPadding = 500.0;
const minPlayerDistance = 200.0;
const portalSpawnDistance = 5000.0;
const minPlanetDistance = 500.0;

class StageGenerator {
  StageGenerator({
    required this.commands,
    required this.assetManager,
    required this.stageConfig,
    required this.stage,
  });

  final Commands commands;
  final AssetManager assetManager;
  final StageConfig stageConfig;
  final Entity stage;

  final random = math.Random();
  final blueprint = StageBlueprint();

  Future<void> generate() async {
    final StageConfig(:stageSize) = stageConfig;

    // player
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
    blueprint.player = SpawnFootprint(
      position: playerSpawnPosition,
      radius: minPlanetDistance,
    );

    _spawnStageBordersDebug(stageSize);

    // regions
    final leftBottomDistance = stageSize - playerSpawnPosition;
    final maxEdgeDistance = math.max(
      math.max(playerSpawnPosition.x, leftBottomDistance.x),
      math.max(playerSpawnPosition.y, leftBottomDistance.y),
    );

    final regionFractions = [0, 0.25, 0.5, 0.75, 1.0];
    final regionDistances = regionFractions
        .map((f) => maxEdgeDistance * f)
        .toList();
    _spawnRegionDebug(playerSpawnPosition, regionDistances);

    // portal
    late Vector2 portalSpawnPosition;
    do {
      final portalSpawnAngle = 2 * math.pi * random.nextDouble();
      final portalSpawnVector = Vector2(
        math.cos(portalSpawnAngle),
        math.sin(portalSpawnAngle),
      ).normalized();
      portalSpawnPosition =
          playerSpawnPosition + portalSpawnVector * portalSpawnDistance;
    } while (!stageSize.toRect().contains(portalSpawnPosition.toOffset()));

    blueprint.portal = PortalSpawnSpec(
      position: portalSpawnPosition,
      parent: stage,
    );

    // planets
    for (int i = 0; i < regionDistances.length - 1; i++) {
      final min = regionDistances[i];
      final max = regionDistances[i + 1];

      for (int j = 0; j < 3; j++) {
        final position = _getRandomPosition(
          center: playerSpawnPosition,
          min: min,
          max: max,
          radius: 300,
        );
        if (position == null) continue;

        blueprint.planets.add(
          PlanetSpawnSpec(
            image: await assetManager.loadImage(
              'assets/planets/planet_0${random.nextInt(7) + 1}.png',
            ),
            radius: 300,
            mass: 6e16,
            position: position,
            parent: stage,
          ),
        );
      }
    }

    // asteroids
    final asteroidsImage = await assetManager.loadImage('assets/asteroids.png');
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
            rotation: random.nextDouble() * 2 * math.pi,
            variant: random.nextInt(9),
            parent: stage,
          ),
        );
      }
    }

    // background
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
        parallax: 0.9,
        parent: stage,
      ),
    );

    commands.spawn(createPortal(blueprint.portal));
    for (final spec in blueprint.planets) {
      commands.spawn(createPlanet(spec));
    }
    for (final spec in blueprint.asteroids) {
      commands.spawn(createAsteroid(spec));
    }
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
      final angle = 2 * math.pi * random.nextDouble();
      final vector = Vector2(math.cos(angle), math.sin(angle));
      final distance = (max - min) * random.nextDouble() + min;
      position = center + vector * distance;
      count++;
      if (count > 100000) {
        return null;
      }
    } while (!stageConfig.stageSize.toRect().contains(position.toOffset()) ||
        blueprint.occupied.containsWhere(
          (footprint) =>
              footprint.position.distanceTo(position) <
              footprint.radius + radius + minPlanetDistance,
        ));
    return position;
  }

  void _spawnStageBordersDebug(final Vector2 stageSize) {
    commands.spawn(
      Entity()
        ..add(Transform())
        ..add(
          RectangleShape(
            size: stageSize.toSize(),
            paint: Paint()
              ..color = Color(0xffff0000)
              ..style = .stroke
              ..strokeWidth = 10.0,
          ),
        )
        ..add(Parent(parent: stage)),
    );
  }

  void _spawnRegionDebug(final Vector2 center, final List<double> distances) {
    for (final distance in distances) {
      commands.spawn(
        Entity()
          ..add(Transform(position: center))
          ..add(
            CircleShape(
              radius: distance,
              paint: Paint()
                ..color = Color(0xffff0000)
                ..style = .stroke
                ..strokeWidth = 10.0,
            ),
          )
          ..add(Parent(parent: stage)),
      );
    }
  }
}

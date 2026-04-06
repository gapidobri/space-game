import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/asteroid/asteroid_factory.dart';
import 'package:space_game/game/astronaut/astronaut_factory.dart';
import 'package:space_game/game/astronaut/astronaut_location.dart';
import 'package:space_game/game/astronaut/astronaut_spawn_spec.dart';
import 'package:space_game/game/background/background_factory.dart';
import 'package:space_game/game/objective/objective_factory.dart';
import 'package:space_game/game/planet/planet_factory.dart';
import 'package:space_game/game/planet/planet_spawn_spec.dart';
import 'package:space_game/game/portal/portal_factory.dart';
import 'package:space_game/game/stage/components/stage_spawn_point.dart';
import 'package:space_game/game/stage/stage_blueprint.dart';

class StageSpawner {
  StageSpawner({
    required this.commands,
    required this.assetManager,
    required this.blueprint,
    required this.stage,
  });

  final Commands commands;
  final AssetManager assetManager;
  final StageBlueprint blueprint;
  final Entity stage;

  final _planets = <PlanetSpawnSpec, Entity>{};
  final _astronauts = <AstronautSpawnSpec, Entity>{};

  Future<void> spawn() async {
    stage.add(StageSpawnPoint(playerPosition: blueprint.spawnPoint.position));

    commands.spawn(createPortal(spec: blueprint.portal, parent: stage));

    for (final spec in blueprint.planets) {
      final planet = createPlanet(spec: spec, parent: stage);
      _planets[spec] = planet;
      commands.spawn(planet);
    }

    for (final spec in blueprint.asteroids) {
      commands.spawn(createAsteroid(spec: spec, parent: stage));
    }

    for (final spec in blueprint.astronauts) {
      final astronaut = createAstronaut(
        image: spec.image,
        location: AstronautLocationOnPlanet(
          planet: _planets[spec.planet]!,
          angle: spec.planetAngle,
        ),
        parent: stage,
      );
      _astronauts[spec] = astronaut;
      commands.spawn(astronaut);
    }

    for (final spec in blueprint.objectives) {
      commands.spawn(
        createObjective(
          kind: spec.kind,
          tier: spec.tier,
          astronaut: _astronauts[spec.astronaut],
          parent: stage,
        ),
      );
    }

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

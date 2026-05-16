import 'package:space_game/game/app/game_session.dart';
import 'package:space_game/game/rocket/rocket_factory.dart';
import 'package:space_game/game/app/system_registry.dart';
import 'package:space_game/game/run/run_factory.dart';
import 'package:space_game/game/settings/settings_factory.dart';

Future<void> bootstrapGame(GameSession session) async {
  final GameSession(:engine, :assetManager) = session;

  await _preloadImages(session);

  engine.addEntity(createSettings());

  final rocketSprite = await assetManager.loadImage('assets/rocket/rocket.png');

  final rocket = createRocket(image: rocketSprite);
  engine.addEntity(rocket);
  engine.addEntity(createEngine(rocket: rocket, image: rocketSprite));
  engine.addEntity(createRocketParticleEmitter(rocket: rocket));

  engine.addEntity(createRun());

  registerGameSystems(session: session);
}

Future<void> _preloadImages(GameSession session) async {
  await session.assetManager.preloadImages([
    'assets/projectiles/big_bullet.png',
    'assets/projectiles/bullet.png',
    'assets/projectiles/torpedo.png',

    'assets/astronaut/astronaut.png',
    'assets/astronaut/indicator.png',
    'assets/astronaut/ship_wreck.png',

    'assets/portals/entry_portal.png',
    'assets/portals/exit_portal.png',
    'assets/portals/exit_portal_indicator.png',

    'assets/background/background_dust.png',
    'assets/background/background_stars.png',

    'assets/asteroids.png',

    'assets/planets/planet_01.png',
    'assets/planets/planet_02.png',
    'assets/planets/planet_03.png',
    'assets/planets/planet_04.png',
    'assets/planets/planet_05.png',
    'assets/planets/planet_06.png',
    'assets/planets/planet_07.png',

    'assets/keyboard.png',

    'assets/aliens/fighter.png',
    'assets/aliens/frigate.png',
    'assets/aliens/torpedo.png',
    'assets/aliens/dreadnought.png',

    'assets/minerals/fuel_mineral.png',
    'assets/minerals/health_mineral.png',
  ]);
}

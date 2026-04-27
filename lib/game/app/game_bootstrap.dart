import 'package:space_game/game/app/game_session.dart';
import 'package:space_game/game/rocket/rocket_factory.dart';
import 'package:space_game/game/app/system_registry.dart';
import 'package:space_game/game/run/run_factory.dart';

Future<void> bootstrapGame(GameSession session) async {
  final GameSession(:engine, :assetManager) = session;

  final rocketSprite = await assetManager.loadImage('assets/rocket/rocket.png');

  final rocket = createRocket(image: rocketSprite);
  engine.addEntity(rocket);
  engine.addEntity(createEngine(rocket: rocket, image: rocketSprite));
  engine.addEntity(createRocketParticleEmitter(rocket: rocket));

  engine.addEntity(createRun());

  registerGameSystems(session: session);
}

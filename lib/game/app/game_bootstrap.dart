import 'package:space_game/game/app/game_session.dart';
import 'package:space_game/game/rocket/rocket_factory.dart';
import 'package:space_game/game/app/system_registry.dart';
import 'package:space_game/game/run/run_factory.dart';

Future<void> bootstrapGame(GameSession session) async {
  final GameSession(:engine, :assetManager) = session;

  engine.addEntity(
    createRocket(image: await assetManager.loadImage('assets/atlas.png')),
  );

  engine.addEntity(createRun());

  // final levelConfig = LevelConfig(planetCount: 7);

  // await generateLevel(session: session, levelConfig: levelConfig);

  registerGameSystems(session: session);
}

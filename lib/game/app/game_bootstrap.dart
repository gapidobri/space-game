import 'package:space_game/game/app/game_session.dart';
import 'package:space_game/game/rocket/rocket_factory.dart';
import 'package:space_game/game/app/system_registry.dart';
import 'package:space_game/game/world/level/level_config.dart';
import 'package:space_game/game/world/level/level_generator.dart';

Future<void> bootstrapGame(GameSession session) async {
  session.engine.addEntity(
    createRocket(
      image: await session.assetManager.loadImage('assets/atlas.png'),
    ),
  );

  registerGameSystems(session: session);

  final levelConfig = LevelConfig(planetCount: 7);

  await generateLevel(session: session, levelConfig: levelConfig);
}

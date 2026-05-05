import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/app/game_session.dart';
import 'package:space_game/game/persistence/codecs.dart';

Future<void> saveGame(GameSession session) async {
  final serializer = WorldStateSerializer();
  DefaultWorldComponentCodecs.register(serializer);
  registerCodecs(serializer);

  final persistence = WorldStatePersistence(
    serializer: serializer,
    format: JsonWorldStateFormat(),
  );

  final saved = persistence.encodeWorld(session.engine.world);

  print(saved);

  persistence.decodeIntoWorld(session.engine.world, saved);
  await hydrateSprites(session.engine.world, session.assetManager);
}

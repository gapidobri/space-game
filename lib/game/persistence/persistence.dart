import 'dart:io';

import 'package:gamengine/gamengine.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:space_game/game/app/game_session.dart';
import 'package:space_game/game/persistence/codecs.dart';

class Persistence {
  Persistence._() {
    final serializer = WorldStateSerializer();
    DefaultWorldComponentCodecs.register(serializer);
    registerCodecs(serializer);

    persistence = WorldStatePersistence(
      serializer: serializer,
      format: JsonWorldStateFormat(),
    );
  }

  static final Persistence _instance = Persistence._();

  static Persistence get instance => _instance;

  late final WorldStatePersistence<String> persistence;

  Future<void> saveGame(GameSession session, String name) async {
    final saved = persistence.encodeWorld(session.engine.world);

    final file = File(
      await getApplicationDocumentsDirectory().then(
        (dir) => path.join(dir.path, 'saves', '$name.json'),
      ),
    );

    await file.create(recursive: true);
    await file.writeAsString(saved);
  }

  Future<List<String>> listSaves() async {
    final savesDirectory = await getApplicationDocumentsDirectory().then(
      (dir) => path.join(dir.path, 'saves'),
    );

    final dir = Directory(savesDirectory);
    if (!await dir.exists()) {
      return [];
    }

    final files = await dir.list().toList();
    return files
        .whereType<File>()
        .where((file) => path.extension(file.path) == '.json')
        .map((file) => path.basenameWithoutExtension(file.path))
        .toList();
  }

  Future<void> deleteSave(String fileName) async {
    final filePath = await getApplicationDocumentsDirectory().then(
      (dir) => path.join(dir.path, 'saves', '$fileName.json'),
    );

    await File(filePath).delete();
  }

  Future<void> loadGame(GameSession session, String fileName) async {
    final documentsDirectory = await getApplicationDocumentsDirectory().then(
      (dir) => path.join(dir.path, 'saves', '$fileName.json'),
    );

    final file = File(documentsDirectory);
    if (!await file.exists()) {
      throw Exception('Save file not found');
    }

    final data = await file.readAsString();
    persistence.decodeIntoWorld(session.engine.world, data);
    await hydrateSprites(session.engine.world, session.assetManager);
  }
}

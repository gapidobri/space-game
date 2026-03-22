import 'package:flutter/material.dart';
import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/app/game_bootstrap.dart';
import 'package:space_game/game/app/game_session.dart';
import 'package:space_game/game/hud/game_overlay.dart';

class SpaceGame extends StatefulWidget {
  const SpaceGame({super.key});

  @override
  State<SpaceGame> createState() => _SpaceGameState();
}

class _SpaceGameState extends State<SpaceGame> {
  late final GameSession _session;
  late final Future<void> _setupFuture;

  @override
  void initState() {
    super.initState();

    _session = createGameSession();
    _setupFuture = bootstrapGame(_session);
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _setupFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != .done) {
          return Center(child: CircularProgressIndicator());
        }

        return Stack(
          children: [
            GameView(
              engine: _session.engine,
              queue: _session.renderQueue,
              camera: _session.cameraState,
            ),
            GameOverlay(
              hudStateStore: _session.hudStateStore,
              eventBus: _session.engine.eventBus,
            ),
          ],
        );
      },
    );
  }
}

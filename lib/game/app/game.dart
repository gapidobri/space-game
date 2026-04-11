import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/app/game_bootstrap.dart';
import 'package:space_game/game/app/game_session.dart';
import 'package:space_game/game/hud/game_overlay.dart';
import 'package:space_game/game/run/components/run_state.dart';
import 'package:space_game/ui/pause_menu.dart';

class SpaceGame extends StatefulWidget {
  const SpaceGame({super.key});

  @override
  State<SpaceGame> createState() => _SpaceGameState();
}

class _SpaceGameState extends State<SpaceGame> {
  late GameSession _session;

  bool _paused = false;

  @override
  void initState() {
    super.initState();
    _setupGame();
  }

  void _setupGame() {
    setState(() {
      _session = createGameSession();
      bootstrapGame(_session);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GameView(
          engine: _session.engine,
          queue: _session.renderQueue,
          camera: _session.cameraState,
          paused: _paused,
          onKeyEvent: (event) {
            if (event is KeyDownEvent && event.logicalKey == .escape) {
              setState(() => _paused = !_paused);
            }
          },
        ),
        GameOverlay(
          hudStateStore: _session.hudStateStore,
          eventBus: _session.engine.eventBus,
          onReset: _setupGame,
        ),
        Padding(
          padding: const EdgeInsets.only(top: 16.0),
          child: Align(
            alignment: Alignment.topCenter,
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                ElevatedButton(
                  onPressed: () =>
                      _session.engine.world.tryGetComponent<RunState>()?.phase =
                          .stageExit,
                  child: Text('Complete stage'),
                ),
              ],
            ),
          ),
        ),
        if (_paused) PauseMenu(onResume: () => setState(() => _paused = false)),
      ],
    );
  }
}

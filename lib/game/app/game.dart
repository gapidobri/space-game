import 'package:flutter/material.dart' hide Transform;
import 'package:flutter/services.dart';
import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/app/game_bootstrap.dart';
import 'package:space_game/game/app/game_session.dart';
import 'package:space_game/game/hud/game_overlay.dart';
import 'package:space_game/game/persistence/persistence.dart';
import 'package:space_game/game/settings/audio_settings.dart';
import 'package:space_game/settings.dart';
import 'package:space_game/ui/console/console.dart';
import 'package:space_game/ui/pause_menu.dart';

class SpaceGame extends StatefulWidget {
  const SpaceGame({super.key, this.saveFile});

  final String? saveFile;

  @override
  State<SpaceGame> createState() => _SpaceGameState();
}

class _SpaceGameState extends State<SpaceGame> {
  late GameSession _session;
  SettingsController? _settings;

  bool _ready = false;
  bool _paused = false;
  bool _consoleOpen = false;

  @override
  void initState() {
    super.initState();

    _setupGame(saveFile: widget.saveFile);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final next = SettingsScope.of(context);
    if (identical(_settings, next)) return;

    _settings?.removeListener(_onSettingsChanged);
    _settings = next;
    _settings?.addListener(_onSettingsChanged);

    _onSettingsChanged();
  }

  void _onSettingsChanged() {
    if (!_ready) return;
    final data = _settings!.value;

    final audio = _session.engine.world.tryGetComponent<AudioSettings>();
    if (audio != null) {
      audio.musicVolume = data.musicEnabled ? data.musicVolume : 0;
      audio.sfxVolume = data.sfxEnabled ? data.sfxVolume : 0;
    }
  }

  void _setupGame({String? saveFile}) async {
    _session = createGameSession();
    await bootstrapGame(_session);
    if (saveFile != null) {
      await Persistence.instance.loadGame(_session, saveFile);
      final playerPosition = _session.engine.world
          .query<CameraFollowTarget>()
          .firstOrNull
          ?.get<Transform>()
          .position;
      if (playerPosition != null) {
        _session.cameraState.position.setFrom(playerPosition);
      }
    }
    setState(() => _ready = true);
    _onSettingsChanged();
  }

  @override
  void dispose() {
    _settings?.removeListener(_onSettingsChanged);
    super.dispose();
  }

  void _setPaused(bool paused) {
    setState(() => _paused = paused);
    _session.engine.paused = paused;
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        GameView(
          engine: _session.engine,
          queue: _session.renderQueue,
          camera: _session.cameraState,
          paused: !_ready || _paused,
          onKeyEvent: (event) {
            if (event is KeyDownEvent) {
              switch (event.logicalKey) {
                case .escape:
                  _setPaused(!_paused);
                  break;
                case .intlBackslash:
                  setState(() => _consoleOpen = !_consoleOpen);
                  break;
              }
            }
          },
        ),
        GameOverlay(
          hudStateStore: _session.hudStateStore,
          eventBus: _session.engine.eventBus,
          onReset: () {
            _session.engine.dispose();
            _setupGame(saveFile: null);
          },
        ),

        if (_paused)
          PauseMenu(
            onResume: () => _setPaused(false),
            onSave: (name) => Persistence.instance.saveGame(_session, name),
          ),
        if (_consoleOpen)
          Positioned(
            left: 16,
            bottom: 16,
            child: Console(
              session: _session,
              onClose: () => setState(() => _consoleOpen = false),
            ),
          ),
      ],
    );
  }
}

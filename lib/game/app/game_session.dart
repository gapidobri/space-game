import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/hud/hud_data.dart';
import 'package:space_game/game/shared/input/input.dart';

GameSession createGameSession() {
  final eventBus = EventBus();

  return GameSession(
    engine: Engine(eventBus: eventBus),
    inputState: InputActionState<InputAction>(),
    cameraState: CameraState(),
    renderQueue: RenderQueue(),
    assetManager: AssetManager(),
    hudStateStore: HudStateStore(HudData()),
  );
}

class GameSession {
  const GameSession({
    required this.engine,
    required this.inputState,
    required this.cameraState,
    required this.renderQueue,
    required this.assetManager,
    required this.hudStateStore,
  });

  final Engine engine;
  final InputActionState<InputAction> inputState;
  final CameraState cameraState;
  final RenderQueue renderQueue;
  final AssetManager assetManager;
  final HudStateStore<HudData> hudStateStore;
}

import 'package:flutter/material.dart';
import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/input.dart';
import 'package:space_game/game/planet/planet.dart';
import 'package:space_game/game/rocket/rocket.dart';
import 'package:space_game/game/rocket/systems/rocket_control.dart';

class SpaceGame extends StatefulWidget {
  const SpaceGame({super.key});

  @override
  State<SpaceGame> createState() => _SpaceGameState();
}

class _SpaceGameState extends State<SpaceGame> {
  static const double _gravityConstant = 1.0;

  late final Engine _engine;
  late final World _world;
  late final EventBus _eventBus;
  late final InputActionState<InputAction> _inputState;
  late final CameraState _camera;
  late final RenderQueue _renderQueue;
  late final AssetManager _assetManager;

  late final Future<void> _setupFuture;

  @override
  void initState() {
    super.initState();

    _assetManager = AssetManager();

    _world = World();
    _eventBus = EventBus();
    _inputState = InputActionState<InputAction>();
    _camera = CameraState();
    _renderQueue = RenderQueue();
    _engine = Engine(world: _world, events: _eventBus);

    _setupFuture = _setupGame();
  }

  Future<void> _setupGame() async {
    final rocket = await Rocket.create(assetManager: _assetManager);
    _engine.addEntity(rocket);

    final planet = await Planet.create(
      assetManager: _assetManager,
      position: Vector2(400, 0),
    );
    _engine.addEntity(planet);

    _engine.addSystem(
      InputSystem(
        eventBus: _eventBus,
        actionState: _inputState,
        keymap: InputKeymap<InputAction>()
          ..registerAction(action: .rotateLeft, keys: [.arrowLeft, .keyA])
          ..registerAction(action: .rotateRight, keys: [.arrowRight, .keyD])
          ..registerAction(action: .thrust, keys: [.space])
          ..registerAction(action: .boost, keys: [.shift]),
      ),
    );

    _engine.addSystem(
      RocketControlSystem(world: _world, inputState: _inputState),
    );

    _engine.addSystem(
      PhysicsSystem(world: _world, gravitationalConstant: _gravityConstant),
    );

    _engine.addSystem(CollisionSystem(world: _world, eventBus: _eventBus));

    _engine.addSystem(CameraFollowSystem(camera: _camera, target: rocket));

    _engine.addSystem(
      RenderSystem(world: _world, queue: _renderQueue, camera: _camera),
    );
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder(
      future: _setupFuture,
      builder: (context, snapshot) {
        if (snapshot.connectionState != .done) {
          // TODO: show proper loading screen
          return Center(child: CircularProgressIndicator());
        }

        return GameView(engine: _engine, queue: _renderQueue, camera: _camera);
      },
    );
  }
}

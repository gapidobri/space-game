import 'dart:math';

import 'package:flutter/material.dart';
import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/systems/alien_movement_system.dart';
import 'package:space_game/game/input.dart';
import 'package:space_game/game/level/level_config.dart';
import 'package:space_game/game/planet/atmosphere/atmosphere_system.dart';
import 'package:space_game/game/planet/planet.dart';
import 'package:space_game/game/rocket/rocket.dart';
import 'package:space_game/game/rocket/systems/rocket_control_system.dart';

class SpaceGame extends StatefulWidget {
  const SpaceGame({super.key});

  @override
  State<SpaceGame> createState() => _SpaceGameState();
}

class _SpaceGameState extends State<SpaceGame> {
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

    _engine.addSystem(
      RocketControlSystem(world: _world, inputState: _inputState),
    );

    final levelConfig = LevelConfig(planetCount: 7);

    await _generateLevel(levelConfig);

    // _engine.addEntity(await Alien.create(assetManager: _assetManager));
    _engine.addSystem(AlienMovementSystem(target: rocket, world: _world));

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

    _engine.addSystem(AtmosphereSystem(world: _world));

    _engine.addSystem(PhysicsSystem(world: _world));

    _engine.addSystem(CollisionSystem(world: _world, eventBus: _eventBus));

    _engine.addSystem(CameraFollowSystem(camera: _camera, target: rocket));

    _engine.addSystem(
      RenderSystem(world: _world, queue: _renderQueue, camera: _camera),
    );
  }

  Future<void> _generateLevel(LevelConfig config) async {
    await _generatePlanets(config);
  }

  Future<void> _generatePlanets(LevelConfig config) async {
    final random = Random();

    for (int i = 0; i < config.planetCount; i++) {
      final image = await _assetManager.loadImage(
        'assets/planets/planet_0${i + 1}.png',
      );

      _engine.addEntity(
        PlanetBuilder(
          image: image,
          position: Vector2(
            random.nextDouble() * 5000 - 2500,
            random.nextDouble() * 5000 - 2500,
          ),
          mass: 6e16,
          atmosphere: AtmosphereBuilder(
            drag: 10,
            color: Color.fromARGB(50, 255, 100, 100),
          ),
        ).build(),
      );
    }
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

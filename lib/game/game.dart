import 'dart:math';
import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/systems/alien_movement_system.dart';
import 'package:space_game/game/astronaut/astronaut.dart';
import 'package:space_game/game/astronaut/astronaut_location.dart';
import 'package:space_game/game/astronaut/astronaut_system.dart';
import 'package:space_game/game/background/background.dart';
import 'package:space_game/game/background/parallax_system.dart';
import 'package:space_game/game/damage/damagable.dart';
import 'package:space_game/game/damage/damage_system.dart';
import 'package:space_game/game/hud/hud_data.dart';
import 'package:space_game/game/input.dart';
import 'package:space_game/game/interaction/interaction_attempt_event.dart';
import 'package:space_game/game/interaction/interaction_event.dart';
import 'package:space_game/game/interaction/interaction_indicator_system.dart';
import 'package:space_game/game/interaction/interaction_system.dart';
import 'package:space_game/game/level/level_config.dart';
import 'package:space_game/game/mining/minable.dart';
import 'package:space_game/game/mining/mineral.dart';
import 'package:space_game/game/mining/mining_system.dart';
import 'package:space_game/game/planet/atmosphere/atmosphere_system.dart';
import 'package:space_game/game/planet/occupancy/planet_occupancy_system.dart';
import 'package:space_game/game/planet/planet.dart';
import 'package:space_game/game/rocket/astronaut_rescue/astronaut_rescue_system.dart';
import 'package:space_game/game/rocket/astronaut_rescue/rescue_attempt_event.dart';
import 'package:space_game/game/rocket/components/eva.dart';
import 'package:space_game/game/rocket/components/fuel_tank.dart';
import 'package:space_game/game/rocket/components/rocket_location.dart';
import 'package:space_game/game/rocket/rocket.dart';
import 'package:space_game/game/rocket/systems/landing_assistance_system.dart';
import 'package:space_game/game/rocket/systems/rocket_control_system.dart';
import 'package:space_game/game/utils.dart';

class SpaceGame extends StatefulWidget {
  const SpaceGame({super.key});

  @override
  State<SpaceGame> createState() => _SpaceGameState();
}

class _SpaceGameState extends State<SpaceGame> {
  late final Engine _engine;

  late final EventBus _eventBus;
  late final InputActionState<InputAction> _inputState;
  late final CameraState _camera;
  late final RenderQueue _renderQueue;
  late final AssetManager _assetManager;
  late final HudStateStore<HudData> _hudStateStore;

  late final Future<void> _setupFuture;

  @override
  void initState() {
    super.initState();

    _assetManager = AssetManager();

    _eventBus = EventBus();
    _inputState = InputActionState<InputAction>();
    _camera = CameraState();
    _renderQueue = RenderQueue();
    _engine = Engine(events: _eventBus);
    _hudStateStore = HudStateStore(HudData());

    _setupFuture = _setupGame();
  }

  Future<void> _setupGame() async {
    final rocket = await RocketBuilder.create(assetManager: _assetManager);
    _engine.addEntity(rocket);

    _engine.addSystem(RocketControlSystem(inputState: _inputState));

    final levelConfig = LevelConfig(planetCount: 7);

    await _generateLevel(levelConfig);

    // _engine.addEntity(await Alien.create(assetManager: _assetManager));
    _engine.addSystem(AlienMovementSystem(target: rocket));

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

    _engine.addSystem(AstronautSystem());
    _engine.addSystem(InteractionIndicatorSystem());
    _engine.addSystem(AstronautRescueSystem(eventBus: _eventBus));

    _engine.addSystem(ParallaxSystem(camera: _camera));
    _engine.addSystem(SpriteAnimationSystem());

    _engine.addSystem(AtmosphereSystem());
    _engine.addSystem(LandingAssistanceSystem(eventBus: _eventBus));
    _engine.addSystem(PhysicsSystem());
    _engine.addSystem(CollisionSystem(eventBus: _eventBus));
    _engine.addSystem(DamageSystem(eventBus: _eventBus));
    _engine.addSystem(PlanetOccupancySystem());
    _engine.addSystem(InteractionSystem(eventBus: _eventBus));
    _engine.addSystem(MiningSystem(eventBus: _eventBus));
    _engine.addSystem(ParentSystem());

    _engine.addSystem(CameraFollowSystem(camera: _camera, target: rocket));
    _engine.addSystem(RenderSystem(queue: _renderQueue, camera: _camera));
    _engine.addSystem(
      HudPresenterSystem(
        output: _hudStateStore,
        project: (world) {
          final rocket = world.query<RocketTag>().first;
          final fuelTank = rocket.get<FuelTank>();
          final damagable = rocket.get<Damagable>();
          final rocketLocationStore = rocket.get<RocketLocationStore>();
          final eva = rocket.get<Eva>();

          return HudData(
            maxFuel: fuelTank.maxFuel,
            fuel: fuelTank.fuel,
            maxHealth: damagable.maxHealth,
            health: damagable.health,
            rocketLocation: rocketLocationStore.location,
            canRescue: eva.interactables.containsWhere(
              (e) => e.has<AstronautTag>(),
            ),
            minables: eva.interactables.where((e) => e.has<Minable>()).toList(),
          );
        },
      ),
    );
  }

  Future<void> _generateLevel(LevelConfig config) async {
    // await _generatePlanets(config);

    _engine.addEntity(
      BackgroundBuilder(
        image: await _assetManager.loadImage(
          'assets/background/background_dust.png',
        ),
        parallax: 0.9,
      ).build(),
    );
    _engine.addEntity(
      BackgroundBuilder(
        image: await _assetManager.loadImage(
          'assets/background/background_stars.png',
        ),
        parallax: 0.89,
      ).build(),
    );

    final image = await _assetManager.loadImage('assets/planets/planet_03.png');

    final planet =
        PlanetBuilder(image: image, position: Vector2(0, 500), mass: 6e16)
            .withAtmosphere(
              AtmosphereBuilder(
                drag: 10,
                color: Color.fromARGB(50, 255, 100, 100),
                radius: 500,
              ),
            )
            .build();
    _engine.addEntity(planet);

    final astronaut = AstronautBuilder(
      image: await _assetManager.loadImage('assets/atlas.png'),
      location: AstronautLocationOnPlanet(
        planet: planet,
        angle: Random().nextDouble() * 2 * math.pi,
      ),
    ).build();
    _engine.addEntity(astronaut);

    final mineral = MineralBuilder(
      planet: planet,
      planetAngle: -pi / 2,
    ).build();
    _engine.addEntity(mineral);
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
            )
            .withAtmosphere(
              AtmosphereBuilder(
                drag: 10,
                color: Color.fromARGB(50, 255, 100, 100),
                radius: 500,
              ),
            )
            .build(),
      );
    }
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
            GameView(engine: _engine, queue: _renderQueue, camera: _camera),
            Positioned(
              top: 16,
              left: 16,
              child: Material(
                color: Colors.black,
                child: ValueListenableBuilder(
                  valueListenable: _hudStateStore,
                  builder: (context, state, _) => Text(
                    [
                      'Fuel: ${state.fuel.toInt()}/${state.maxFuel.toInt()}',
                      'Health: ${state.health.toInt()}/${state.maxHealth.toInt()}',
                      'Rocket Location: ${state.rocketLocation.runtimeType}',
                    ].join('\n'),
                    style: TextStyle(color: Colors.white),
                  ),
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: ValueListenableBuilder(
                  valueListenable: _hudStateStore,
                  builder: (context, state, _) => Row(
                    mainAxisSize: MainAxisSize.min,
                    spacing: 4.0,
                    children: [
                      Visibility(
                        visible: state.canRescue,
                        child: ElevatedButton(
                          onPressed: () => _eventBus.emit(RescueAttemptEvent()),
                          child: Text('Rescue'),
                        ),
                      ),
                      for (final entity in state.minables)
                        ElevatedButton(
                          onPressed: () => _eventBus.emit(
                            InteractionAttemptEvent(entity: entity),
                          ),
                          child: Text('Mine'),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

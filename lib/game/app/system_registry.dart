import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/systems/alien_movement_system.dart';
import 'package:space_game/game/astronaut/astronaut_system.dart';
import 'package:space_game/game/background/parallax_system.dart';
import 'package:space_game/game/shared/damage/damage_system.dart';
import 'package:space_game/game/app/game_session.dart';
import 'package:space_game/game/hud/hud_projector.dart';
import 'package:space_game/game/hud/offscreen_indicator/offscreen_indicator_render_pass.dart';
import 'package:space_game/game/shared/input/input.dart';
import 'package:space_game/game/interaction/interaction_indicator_system.dart';
import 'package:space_game/game/interaction/interaction_system.dart';
import 'package:space_game/game/mining/mining_system.dart';
import 'package:space_game/game/planet/atmosphere/atmosphere_system.dart';
import 'package:space_game/game/planet/occupancy/planet_occupancy_system.dart';
import 'package:space_game/game/rocket/rescue/astronaut_rescue_system.dart';
import 'package:space_game/game/rocket/systems/landing_assistance_system.dart';
import 'package:space_game/game/rocket/systems/rocket_control_system.dart';

void registerGameSystems({required GameSession session}) {
  final GameSession(
    :engine,
    :inputState,
    :cameraState,
    :hudStateStore,
    :renderQueue,
  ) = session;

  // input
  engine.addSystem(
    InputSystem(
      eventBus: engine.eventBus,
      actionState: inputState,
      keymap: InputKeymap<InputAction>()
        ..registerAction(action: .rotateLeft, keys: [.arrowLeft, .keyA])
        ..registerAction(action: .rotateRight, keys: [.arrowRight, .keyD])
        ..registerAction(action: .thrust, keys: [.space])
        ..registerAction(action: .boost, keys: [.shift]),
    ),
  );

  // simulation
  engine.addSystem(AtmosphereSystem());
  engine.addSystem(RocketControlSystem(inputState: inputState));
  engine.addSystem(AlienMovementSystem());

  // physics
  engine.addSystem(PhysicsSystem());
  engine.addSystem(CollisionSystem(eventBus: engine.eventBus));

  // gameplay resolution
  engine.addSystem(AstronautSystem());
  engine.addSystem(LandingAssistanceSystem(eventBus: engine.eventBus));
  engine.addSystem(DamageSystem(eventBus: engine.eventBus));
  engine.addSystem(PlanetOccupancySystem());

  // interaction
  engine.addSystem(InteractionSystem(eventBus: engine.eventBus));
  engine.addSystem(AstronautRescueSystem(eventBus: engine.eventBus));
  engine.addSystem(MiningSystem(eventBus: engine.eventBus));

  // presentation
  engine.addSystem(InteractionIndicatorSystem());
  engine.addSystem(ParallaxSystem(cameraState: cameraState));
  engine.addSystem(SpriteAnimationSystem());
  engine.addSystem(CameraFollowSystem(camera: cameraState));
  engine.addSystem(
    HudPresenterSystem(output: hudStateStore, project: projectHudData),
  );

  // cleanup
  engine.addSystem(ParentSystem());

  // render
  final renderSystem = RenderSystem(queue: renderQueue, camera: cameraState);
  renderSystem.addPass(OffscreenIndicatorRenderPass());
  engine.addSystem(renderSystem);
}

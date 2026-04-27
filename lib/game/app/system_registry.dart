import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/systems/alien_movement_system.dart';
import 'package:space_game/game/astronaut/astronaut_system.dart';
import 'package:space_game/game/background/parallax_system.dart';
import 'package:space_game/game/entry_portal/entry_portal_transition_system.dart';
import 'package:space_game/game/objective/systems/objective_system.dart';
import 'package:space_game/game/particle_system/particle_system.dart';
import 'package:space_game/game/portal/exit_portal_transition_system.dart';
import 'package:space_game/game/portal/portal_system.dart';
import 'package:space_game/game/rocket/systems/rocket_destruction_system.dart';
import 'package:space_game/game/rocket/systems/rocket_visual_system.dart';
import 'package:space_game/game/run/systems/run_flow_system.dart';
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
import 'package:space_game/game/stage/systems/stage_cleanup_system.dart';
import 'package:space_game/game/stage/systems/stage_flow_system.dart';
import 'package:space_game/game/stage/systems/stage_setup_system.dart';
import 'package:space_game/game/stage/systems/stage_transition_system.dart';

void registerGameSystems({required GameSession session}) {
  final GameSession(
    :engine,
    :inputState,
    :cameraState,
    :hudStateStore,
    :renderQueue,
    :assetManager,
  ) = session;

  // input
  engine.addSystem(
    InputSystem(
      eventBus: engine.eventBus,
      actionState: inputState,
      keymap: createInputKeymap(),
    ),
  );

  // simulation
  engine.addSystem(AtmosphereSystem());
  engine.addSystem(RocketControlSystem(inputState: inputState));
  engine.addSystem(AlienMovementSystem());

  // physics
  engine.addSystem(PhysicsSystem());
  engine.addSystem(CollisionSystem(eventBus: engine.eventBus));
  engine.addSystem(ParticleSystem());

  // run
  engine.addSystem(RunFlowSystem(eventBus: engine.eventBus));
  engine.addSystem(StageSetupSystem(assetManager: assetManager));
  engine.addSystem(StageTransitionSystem(cameraState: cameraState));
  engine.addSystem(StageCleanupSystem());
  engine.addSystem(ObjectiveSystem(eventBus: engine.eventBus));
  engine.addSystem(StageFlowSystem(eventBus: engine.eventBus));

  // gameplay resolution
  engine.addSystem(AstronautSystem());
  engine.addSystem(LandingAssistanceSystem(eventBus: engine.eventBus));
  engine.addSystem(DamageSystem(eventBus: engine.eventBus));
  engine.addSystem(RocketDestructionSystem(eventBus: engine.eventBus));
  engine.addSystem(PlanetOccupancySystem());
  engine.addSystem(TransformHierarchySystem());
  engine.addSystem(EntryPortalTransitionSystem());
  engine.addSystem(ExitPortalTransitionSystem());

  // interaction
  engine.addSystem(InteractionSystem(eventBus: engine.eventBus));
  engine.addSystem(AstronautRescueSystem(eventBus: engine.eventBus));
  engine.addSystem(MiningSystem(eventBus: engine.eventBus));
  engine.addSystem(PortalSystem(eventBus: engine.eventBus));

  // presentation
  engine.addSystem(InteractionIndicatorSystem());
  engine.addSystem(ParallaxSystem(cameraState: cameraState));
  engine.addSystem(SpriteAnimationSystem());
  engine.addSystem(CameraFollowSystem(camera: cameraState));
  engine.addSystem(
    HudPresenterSystem(output: hudStateStore, project: projectHudData),
  );
  engine.addSystem(RocketVisualSystem());

  // cleanup
  engine.addSystem(ParentSystem());

  // render
  final renderSystem = RenderSystem(queue: renderQueue, camera: cameraState);
  renderSystem.addPass(OffscreenIndicatorRenderPass());
  engine.addSystem(renderSystem);
}

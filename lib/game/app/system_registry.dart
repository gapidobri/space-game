import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/alien_shooting_decision_system.dart';
import 'package:space_game/game/alien/alien_shooting_system.dart';
import 'package:space_game/game/alien/alien_target_system.dart';
import 'package:space_game/game/alien/animation/alien_animation_system.dart';
import 'package:space_game/game/alien/destruction/alien_destruction_system.dart';
import 'package:space_game/game/alien/alien_chase_system.dart';
import 'package:space_game/game/alien/spawner/alien_spawner_system.dart';
import 'package:space_game/game/alien/weapon/weapon_cooldown_system.dart';
import 'package:space_game/game/astronaut/astronaut_system.dart';
import 'package:space_game/game/background/parallax_system.dart';
import 'package:space_game/game/entry_portal/entry_portal_transition_system.dart';
import 'package:space_game/game/interaction/interaction_hint_render_pass.dart';
import 'package:space_game/game/objective/systems/objective_system.dart';
import 'package:space_game/game/particle_system/particle_system.dart';
import 'package:space_game/game/exit_portal/exit_portal_transition_system.dart';
import 'package:space_game/game/exit_portal/exit_portal_system.dart';
import 'package:space_game/game/projectile/projectile_homing_system.dart';
import 'package:space_game/game/projectile/projectile_orientation_system.dart';
import 'package:space_game/game/projectile/projectile_spawn_system.dart';
import 'package:space_game/game/rocket/systems/rocket_destruction_system.dart';
import 'package:space_game/game/rocket/systems/rocket_visual_system.dart';
import 'package:space_game/game/run/systems/loading_overlay_animation_system.dart';
import 'package:space_game/game/run/systems/run_flow_system.dart';
import 'package:space_game/game/run/systems/run_timer_ticker_system.dart';
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
import 'package:space_game/game/shared/lifetime/lifetime_system.dart';
import 'package:space_game/game/sound/background_music/background_music_system.dart';
import 'package:space_game/game/sound/sound_effects/sound_effects_system.dart';
import 'package:space_game/game/stage/systems/stage_cleanup_system.dart';
import 'package:space_game/game/stage/systems/stage_flow_system.dart';
import 'package:space_game/game/stage/systems/stage_setup_system.dart';
import 'package:space_game/game/stage/systems/stage_timer_ticker_system.dart';
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
    InputSystem<InputAction>(
      eventBus: engine.eventBus,
      actionState: inputState,
      keymap: createInputKeymap(),
    ),
  );

  // simulation
  engine.addSystem(AtmosphereSystem());
  engine.addSystem(RocketControlSystem(inputState: inputState));

  // physics
  engine.addSystem(PhysicsSystem());
  engine.addSystem(CollisionSystem(eventBus: engine.eventBus));
  engine.addSystem(ParticleSystem());

  // run
  engine.addSystem(RunFlowSystem(eventBus: engine.eventBus));
  engine.addSystem(StageTransitionSystem(cameraState: cameraState));
  engine.addSystem(LoadingOverlayAnimationSystem());
  engine.addSystem(RunTimerTickerSystem());

  // stage
  engine.addSystem(StageFlowSystem(eventBus: engine.eventBus));
  engine.addSystem(StageSetupSystem(assetManager: assetManager));
  engine.addSystem(ObjectiveSystem(eventBus: engine.eventBus));
  engine.addSystem(StageCleanupSystem());
  engine.addSystem(StageTimerTickerSystem());

  // projectile
  engine.addSystem(
    ProjectileSpawnSystem(
      eventBus: engine.eventBus,
      assetManager: assetManager,
    ),
  );
  engine.addSystem(ProjectileOrientationSystem());
  engine.addSystem(ProjectileHomingSystem());

  // alien
  engine.addSystem(AlienChaseSystem());
  engine.addSystem(AlienTargetSystem());
  engine.addSystem(AlienShootingDecisionSystem());
  engine.addSystem(AlienShootingSystem(eventBus: engine.eventBus));
  engine.addSystem(AlienDestructionSystem(eventBus: engine.eventBus));
  engine.addSystem(WeaponCooldownSystem());
  engine.addSystem(AlienAnimationSystem());
  engine.addSystem(
    AlienSpawnerSystem(assetManager: assetManager, cameraState: cameraState),
  );

  // gameplay resolution
  engine.addSystem(AstronautSystem(assetManager: assetManager));
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
  engine.addSystem(ExitPortalSystem(eventBus: engine.eventBus));

  // presentation
  engine.addSystem(InteractionIndicatorSystem());
  engine.addSystem(ParallaxSystem(cameraState: cameraState));
  engine.addSystem(SpriteAnimationSystem());
  engine.addSystem(CameraFollowSystem(camera: cameraState));
  engine.addSystem(
    HudPresenterSystem(output: hudStateStore, project: projectHudData),
  );
  engine.addSystem(RocketVisualSystem());

  // sound
  engine.addSystem(BackgroundMusicSystem());
  engine.addSystem(
    SoundEffectsSystem(priority: -100, eventBus: engine.eventBus),
  );

  // cleanup
  engine.addSystem(ParentSystem());
  engine.addSystem(LifetimeSystem());

  // render
  final renderSystem = RenderSystem(queue: renderQueue, camera: cameraState);
  renderSystem.addPass(OffscreenIndicatorRenderPass());
  renderSystem.addPass(InteractionHintRenderPass(assetManager: assetManager));
  renderSystem.addPass(PhysicsVectorsOverlay());
  engine.addSystem(renderSystem);
}

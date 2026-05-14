import 'dart:math';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/run/components/current_stage.dart';
import 'package:space_game/game/run/components/run_state.dart';
import 'package:space_game/game/stage/components/stage_setup_state.dart';
import 'package:space_game/game/stage/generation/objective_generator.dart';
import 'package:space_game/game/stage/generation/stage_spawner.dart';
import 'package:space_game/game/stage/stage_config.dart';
import 'package:space_game/game/stage/stage_factory.dart';
import 'package:space_game/game/stage/generation/stage_generator.dart';

class StageSetupSystem extends System {
  StageSetupSystem({super.priority, required this.assetManager});

  final AssetManager assetManager;

  @override
  void update(double dt, World world, Commands commands) {
    final run = world.query<RunState>().firstOrNull;
    if (run == null) return;

    final runState = run.get<RunState>();
    if (runState.phase != .stageSetup) return;

    final currentStage = run.get<CurrentStage>().stage;
    if (currentStage != null) return;

    final random = Random();

    // TODO: generate config
    final stageConfig = StageConfig(
      stageSize: Vector2(10000, 10000),
      rescueObjectiveCount: 1,
      fuelMineObjectiveCount: 1,
      healthMineObjectiveCount: 1,
      regionPlanetCount: 3,
      difficultyStages: [
        DifficultyStage(
          timer: 30,
          alienSpawners: [AlienSpawnConfig(type: .fighter, delay: 30)],
        ),
        DifficultyStage(
          timer: 120,
          alienSpawners: [
            AlienSpawnConfig(type: .fighter, delay: 15),
            AlienSpawnConfig(type: .frigate, delay: 50),
          ],
        ),
        DifficultyStage(
          timer: 300,
          alienSpawners: [
            AlienSpawnConfig(type: .fighter, delay: 15),
            AlienSpawnConfig(type: .frigate, delay: 50),
            AlienSpawnConfig(type: .torpedo, delay: 60),
          ],
        ),
      ],
    );

    final bgmIndex = random.nextInt(7) + 1;

    final stage = createStage(
      backgroundMusic: 'assets/music/bgm_$bgmIndex.mp3',
      config: stageConfig,
      parent: run,
    );
    commands.spawn(stage);
    run.get<CurrentStage>().stage = stage;

    final setupState = stage.get<StageSetupState>();

    setupState.status = .generating;

    final blueprint = StageGenerator(
      assetManager: assetManager,
      stageConfig: stageConfig,
      stage: stage,
      random: random,
    ).generate();

    ObjectiveGenerator(
      assetManager: assetManager,
      config: stageConfig,
      blueprint: blueprint,
      random: random,
    ).generate();

    StageSpawner(
      commands: commands,
      assetManager: assetManager,
      blueprint: blueprint,
      stage: stage,
      random: random,
    ).spawn();

    setupState.status = .ready;
  }
}

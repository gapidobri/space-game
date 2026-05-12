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
  void update(double dt, World world, Commands commands) async {
    final run = world.query<RunState>().firstOrNull;
    if (run == null) return;

    final runState = run.get<RunState>();
    if (runState.phase != .stageEnter) return;

    final currentStage = run.get<CurrentStage>().stage;
    if (currentStage != null) return;

    final random = Random();

    // TODO: generate config
    final stageConfig = StageConfig(
      stageSize: Vector2(10000, 10000),
      objectiveCount: 1,
      regionPlanetCount: 0, // TODO: tmp
    );

    final bgmIndex = random.nextInt(7) + 1;

    final stage = createStage(
      backgroundMusic: 'assets/music/bgm_$bgmIndex.mp3',
      parent: run,
    );
    commands.spawn(stage);
    run.get<CurrentStage>().stage = stage;

    final setupState = stage.get<StageSetupState>();

    setupState.status = .generating;

    final blueprint = await StageGenerator(
      assetManager: assetManager,
      stageConfig: stageConfig,
      stage: stage,
      random: random,
    ).generate();

    await ObjectiveGenerator(
      assetManager: assetManager,
      config: stageConfig,
      blueprint: blueprint,
      random: random,
    ).generate();

    await StageSpawner(
      commands: commands,
      assetManager: assetManager,
      blueprint: blueprint,
      stage: stage,
      random: random,
    ).spawn();

    setupState.status = .ready;
  }
}

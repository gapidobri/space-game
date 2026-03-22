import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/run/components/current_stage.dart';
import 'package:space_game/game/run/components/run_state.dart';
import 'package:space_game/game/stage/components/stage_setup_state.dart';
import 'package:space_game/game/stage/stage_config.dart';
import 'package:space_game/game/stage/stage_factory.dart';
import 'package:space_game/game/stage/stage_generator.dart';

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

    final stage = createStage(requiredTeleporterParts: 3, parent: run);
    commands.spawn(stage);
    run.get<CurrentStage>().stage = stage;

    final setupState = stage.get<StageSetupState>();

    setupState.status = .generating;
    // TODO: generate config
    final stageConfig = StageConfig(stageSize: Vector2(10000, 10000));

    await generateStage(
      commands: commands,
      assetManager: assetManager,
      stageConfig: stageConfig,
      stage: stage,
    );

    setupState.status = .ready;
  }
}

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/run/components/run_state.dart';
import 'package:space_game/game/stage/components/stage_setup_state.dart';
import 'package:space_game/game/stage/stage_factory.dart';
import 'package:space_game/game/world/level/level_config.dart';
import 'package:space_game/game/world/level/level_generator.dart';

class StageSetupSystem extends System {
  StageSetupSystem({super.priority, required this.assetManager});

  final AssetManager assetManager;

  @override
  void update(double dt, World world, Commands commands) async {
    final runState = world.tryGetComponent<RunState>();
    if (runState == null || runState.phase != .stageEnter) return;

    var setupState = world.tryGetComponent<StageSetupState>();
    if (setupState != null && setupState.status == .generating) return;

    final stage = createStage(requiredTeleporterParts: 3);
    commands.spawn(stage);

    setupState = stage.get<StageSetupState>();

    // TODO: generate config
    final levelConfig = LevelConfig(planetCount: 7);

    setupState.status = .generating;

    await generateLevel(
      commands: commands,
      assetManager: assetManager,
      levelConfig: levelConfig,
      parent: stage,
    );

    setupState.status = .ready;
  }
}

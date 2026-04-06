import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';
import 'package:space_game/game/run/components/current_stage.dart';
import 'package:space_game/game/run/components/run_state.dart';
import 'package:space_game/game/run/run_tag.dart';
import 'package:space_game/game/stage/components/stage_setup_state.dart';
import 'package:space_game/game/stage/components/stage_spawn_point.dart';
import 'package:space_game/game/stage/components/stage_transition_state.dart';

class StageTransitionSystem extends System {
  StageTransitionSystem({super.priority, required this.cameraState});

  final CameraState cameraState;

  @override
  void update(double dt, World world, Commands commands) {
    final run = world.query<RunTag>().firstOrNull;
    if (run == null) return;

    final stage = run.get<CurrentStage>().stage;
    if (stage == null) return;

    final runState = run.get<RunState>();
    final stageSetupState = stage.get<StageSetupState>();
    if (runState.phase != .stageEnter || stageSetupState.status != .ready) {
      return;
    }

    _transitionPlayer(world, stage);
  }

  void _transitionPlayer(World world, Entity stage) {
    final rocket = world.query<RocketTag>().firstOrNull;
    if (rocket == null) return;

    final stageSpawnPoint = stage.get<StageSpawnPoint>();

    final transform = rocket.get<Transform>();
    transform.position.setFrom(stageSpawnPoint.playerPosition);
    transform.rotation = 0;

    final rigidBody = rocket.get<RigidBody>();
    rigidBody.velocity.setZero();
    rigidBody.angularVelocity = 0;

    cameraState.position.setFrom(stageSpawnPoint.playerPosition);

    stage.get<StageTransitionState>().playerPlaced = true;
  }
}

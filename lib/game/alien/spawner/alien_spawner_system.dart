import 'dart:math';

import 'package:collection/collection.dart';
import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/alien_factory.dart';
import 'package:space_game/game/alien/alien_type.dart';
import 'package:space_game/game/alien/spawner/alien_spawner.dart';
import 'package:space_game/game/alien/spawner/alien_spawner_factory.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';
import 'package:space_game/game/run/components/current_stage.dart';
import 'package:space_game/game/stage/components/stage_config_store.dart';
import 'package:space_game/game/stage/components/stage_state.dart';

class AlienSpawnerSystem extends System {
  AlienSpawnerSystem({
    super.priority,
    required this.cameraState,
    required this.assetManager,
  });

  final CameraState cameraState;
  final AssetManager assetManager;

  final _random = Random();

  @override
  void update(double dt, World world, Commands commands) {
    final currentStage = world.tryGetComponent<CurrentStage>()?.stage;
    if (currentStage == null) return;

    final stageState = currentStage.get<StageState>();
    final stageConfig = currentStage.get<StageConfigStore>().config;

    final currentDiff = stageConfig.difficultyStages.lastWhereOrNull(
      (s) => s.timer < stageState.timer,
    );
    if (currentDiff == null) return;

    final spawners = world.query<AlienSpawner>().map(
      (s) => s.get<AlienSpawner>(),
    );

    final rocket = world.query<RocketTag>().firstOrNull;
    if (rocket == null) return;
    final rocketTransform = rocket.get<Transform>();

    for (final spawnerConfig in currentDiff.alienSpawners) {
      final spawner = spawners.firstWhereOrNull(
        (s) => s.type == spawnerConfig.type,
      );
      if (spawner == null) {
        commands.spawn(createAlienSpawner(type: spawnerConfig.type));
        continue;
      }
      spawner.cooldown -= dt;
      if (spawner.cooldown <= 0) {
        spawner.cooldown += spawnerConfig.delay;

        const padding = 16.0;
        final spawnRadius =
            max(cameraState.viewportWidth, cameraState.viewportHeight) +
            padding;

        final forward = Vector2(1, 0);

        final angle = forward.rotated(_random.nextDoubleBetween(0, 2 * pi));
        final spawnOffset = angle.scaled(spawnRadius);

        final position = rocketTransform.position + spawnOffset;

        switch (spawner.type) {
          case AlienType.fighter:
            commands.spawn(
              createAlienFighter(
                image: assetManager.image('assets/aliens/fighter.png')!,
                position: position,
                parent: currentStage,
              ),
            );
            break;

          case AlienType.torpedo:
            commands.spawn(
              createAlienTorpedo(
                image: assetManager.image('assets/aliens/torpedo.png')!,
                position: position,
                parent: currentStage,
              ),
            );
            break;

          case AlienType.frigate:
            commands.spawn(
              createAlienFrigate(
                image: assetManager.image('assets/aliens/frigate.png')!,
                position: position,
                parent: currentStage,
              ),
            );
            break;

          case AlienType.dreadnought:
            commands.spawn(
              createAlienDreadnought(
                image: assetManager.image('assets/aliens/dreadnought.png')!,
                position: position,
                parent: currentStage,
              ),
            );
            break;
        }
      }
    }
  }
}

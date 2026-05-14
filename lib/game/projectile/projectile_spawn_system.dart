import 'dart:math';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/weapon/weapon.dart';
import 'package:space_game/game/projectile/events/projectile_spawn_request_event.dart';
import 'package:space_game/game/projectile/projectile_factory.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';
import 'package:space_game/game/run/components/current_stage.dart';

class ProjectileSpawnSystem extends System {
  ProjectileSpawnSystem({
    super.priority,
    required this.eventBus,
    required this.assetManager,
  });

  final EventBus eventBus;
  final AssetManager assetManager;

  @override
  void update(double dt, World world, Commands commands) {
    final stage = world.tryGetComponent<CurrentStage>()?.stage;
    if (stage == null) return;

    final rocket = world.query<RocketTag>().firstOrNull;
    if (rocket == null) return;

    for (final event in eventBus.read<ProjectileSpawnRequestEvent>()) {
      final weapon = event.shooter.tryGet<Weapon>();
      if (weapon == null) continue;

      final transform = event.shooter.get<Transform>();
      final rigidBody = event.shooter.get<RigidBody>();

      final position =
          transform.position + event.offset.rotated(transform.rotation);

      final velocity =
          rigidBody.velocity +
          Vector2(sin(transform.rotation), -cos(transform.rotation)) *
              event.velocity;

      Entity projectile;
      switch (weapon.projectileType) {
        case .bullet:
          projectile = createBullet(
            image: assetManager.image('assets/projectiles/bullet.png')!,
            position: position,
            rotation: transform.rotation,
            velocity: velocity,
            parent: stage,
          );
          break;

        case .bigBullet:
          projectile = createBigBullet(
            image: assetManager.image('assets/projectiles/big_bullet.png')!,
            position: position,
            rotation: transform.rotation,
            velocity: velocity,
            parent: stage,
          );

        case .torpedo:
          projectile = createTorpedo(
            image: assetManager.image('assets/projectiles/torpedo.png')!,
            position: position,
            rotation: transform.rotation,
            velocity: velocity,
            target: rocket,
            parent: stage,
          );
          break;
      }

      commands.spawn(projectile);
    }
  }
}

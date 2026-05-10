import 'dart:math';
import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/particle_system/particle.dart';
import 'package:space_game/game/particle_system/particle_emitter.dart';
import 'package:space_game/game/particle_system/particle_factory.dart';
import 'package:space_game/game/run/components/current_stage.dart';

class ParticleSystem extends System {
  final _random = Random();

  @override
  void update(double dt, World world, Commands commands) {
    final currentStageRef = world.tryGetComponent<CurrentStage>();

    for (final entity in world.query2<ParticleEmitter, Transform>()) {
      final emitter = entity.get<ParticleEmitter>();
      if (!emitter.enabled) continue;

      final velocity = Vector2.zero();

      final velocitySource = emitter.velocitySource;
      if (velocitySource != null) {
        final rigidBody = velocitySource.tryGet<RigidBody>();
        if (rigidBody != null) {
          velocity.add(rigidBody.velocity);
        }
      }

      final transform = entity.get<Transform>();

      emitter.nextSpawn -= dt;
      while (emitter.nextSpawn <= 0) {
        emitter.nextSpawn += 1 / emitter.spawnRate;

        for (int i = 0; i < emitter.spawnCount; i++) {
          final rotation =
              transform.rotation +
              _random.nextDoubleBetween(
                -emitter.turbulence,
                emitter.turbulence,
              );

          final spawnOffset = Vector2(
            _random.nextDoubleBetween(
              -emitter.randomSpawnOffset.x,
              emitter.randomSpawnOffset.x,
            ),
            _random.nextDoubleBetween(
              -emitter.randomSpawnOffset.y,
              emitter.randomSpawnOffset.y,
            ),
          ).rotated(transform.rotation);

          final particle = createParticle(
            position: transform.position + spawnOffset,
            rotation: rotation,
            size: emitter.particleSize,
            color: emitter.colors.random() ?? Color(0xffffffff),
            lifetime: _random.nextDoubleBetween(
              emitter.minLifetime,
              emitter.maxLifetime,
            ),
            initialVelocity: velocity.clone()
              ..add(emitter.initialVelocity.rotated(rotation)),
            fadeOutTime: emitter.fadeOutTime,
            mass: emitter.mass,
            parent: currentStageRef?.stage,
          );
          commands.spawn(particle);
        }
      }
    }

    for (final entity in world.query<Particle>()) {
      final particle = entity.get<Particle>();
      particle.lifetime -= dt;
      if (particle.lifetime <= 0) {
        commands.despawn(entity);
      }

      final shape = entity.get<RectangleShape>();
      if (shape.paint != null) {
        final alpha = min(
          particle.lifetime / particle.fadeOutTime,
          1,
        ).toDouble();
        shape.paint?.color = shape.paint!.color.withValues(alpha: alpha);
      }
    }
  }
}

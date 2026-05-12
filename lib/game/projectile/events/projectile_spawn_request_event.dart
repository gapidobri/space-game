import 'dart:ui';

import 'package:gamengine/gamengine.dart';

class ProjectileSpawnRequestEvent extends GameEvent {
  const ProjectileSpawnRequestEvent({
    required this.shooter,
    required this.offset,
    required this.velocity,
  });

  final Entity shooter;

  final Vector2 offset;
  final double velocity;

  // TODO: projectile type
}

import 'dart:ui';

import 'package:gamengine/gamengine.dart';

class ParticleEmitter extends Component {
  ParticleEmitter({
    required this.spawnRate,
    required this.maxLifetime,
    required this.colors,
    required this.particleSize,
    this.enabled = true,
    this.velocitySource,
    this.turbulence = 0,
    this.spawnCount = 1,
    this.fadeOutTime = 0,
    Vector2? initialVelocity,
    Vector2? randomSpawnOffset,
    double? minLifetime,
    double? mass,
  }) : initialVelocity = initialVelocity ?? Vector2.zero(),
       randomSpawnOffset = randomSpawnOffset ?? Vector2.zero(),
       minLifetime = minLifetime ?? maxLifetime;

  bool enabled;
  double spawnRate;
  int spawnCount;
  double turbulence;

  final Entity? velocitySource;
  final Vector2 initialVelocity;
  final Vector2 randomSpawnOffset;
  List<Color> colors;
  final Size particleSize;

  double minLifetime;
  double maxLifetime;
  double fadeOutTime;
  double? mass;

  double nextSpawn = 0;
}

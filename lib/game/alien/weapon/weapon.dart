import 'package:gamengine/gamengine.dart';

enum ProjectileType { bullet, bigBullet, torpedo }

class Weapon extends Component {
  Weapon({
    this.cooldown = 0,
    required this.projectileSpeed,
    required this.projectileType,
    required this.shootFrames,
    this.lastFrame = 0,
    this.cooldownRemaining = 0,
  });

  final double cooldown;

  final double projectileSpeed;
  final ProjectileType projectileType;

  final Map<int, List<Vector2>> shootFrames;

  int lastFrame;
  double cooldownRemaining;
}

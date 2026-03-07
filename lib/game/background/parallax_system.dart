import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/background/parallax.dart';

class ParallaxSystem extends System {
  ParallaxSystem({super.priority, required this.camera});

  final CameraState camera;

  @override
  void update(double dt, World world, Commands commands) {
    for (final entity in world.query<Parallax>()) {
      final parallax = entity.get<Parallax>();
      final transform = entity.get<Transform>();

      transform.position.setFrom(camera.position * parallax.multiplier);
    }
  }
}

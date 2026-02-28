import 'package:gamengine/src/system.dart';
import 'package:gamengine/src/systems/render/camera_state.dart';
import 'package:gamengine/src/systems/render/render_queue.dart';

class RenderSystem extends System {
  final RenderQueue queue;
  final CameraState camera;

  RenderSystem({required this.queue, required this.camera});

  @override
  int get priority => 1000;

  @override
  void update(double dt) {
    queue.beginFrame();

    final view = camera.worldViewRect;

    queue.endFrame();
  }
}

import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/hud/offscreen_indicator/offscreen_indicator.dart';

class OffscreenIndicatorRenderPass extends RenderPass {
  OffscreenIndicatorRenderPass();

  @override
  void write(
    World world, {
    required CameraState camera,
    required RenderQueue queue,
  }) {
    final viewRect = camera.worldViewRect;
    final center = viewRect.center;
    final edgeRect = viewRect.deflate(32.0);

    for (final entity in world.query2<Transform, OffscreenIndicator>()) {
      final indicator = entity.get<OffscreenIndicator>();
      if (!indicator.enabled) continue;

      final transform = entity.get<Transform>();

      final target = transform.position.toOffset();

      if (viewRect.contains(transform.position.toOffset())) {
        continue;
      }

      final dx = target.dx - center.dx;
      final dy = target.dy - center.dy;
      if (dx == 0 && dy == 0) {
        continue;
      }

      final scaleX = dx == 0
          ? double.infinity
          : (edgeRect.width * 0.5) / dx.abs();
      final scaleY = dy == 0
          ? double.infinity
          : (edgeRect.height * 0.5) / dy.abs();
      final t = scaleX < scaleY ? scaleX : scaleY;

      final position = Offset(center.dx + dx * t, center.dy + dy * t);

      queue.add(
        DrawSpriteCommand(
          image: indicator.image.data,
          position: position,
          scaleX: indicator.scale,
          scaleY: indicator.scale,
          z: 10000,
        ),
      );

      queue.add(
        DrawCircleCommand(
          center: position,
          radius: 16,
          z: 9000,
          paint: Paint()
            ..color = Color.fromARGB(255, 0, 255, 17)
            ..maskFilter = MaskFilter.blur(.normal, 16.0),
        ),
      );
    }
  }
}

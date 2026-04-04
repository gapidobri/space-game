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
    final edgeRect = viewRect.deflate(24.0);

    for (final entity in world.query2<Transform, OffscreenIndicator>()) {
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

      queue.add(
        DrawCircleCommand(
          center: Offset(center.dx + dx * t, center.dy + dy * t),
          radius: 8,
          z: 10000,
          paint: Paint()..color = Color(0xff00ff00),
        ),
      );
    }
  }
}

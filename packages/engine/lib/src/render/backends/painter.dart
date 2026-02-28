import 'package:flutter/material.dart';
import 'package:gamengine/src/render/camera/camera_state.dart';
import 'package:gamengine/src/render/commands/render_commands.dart';
import 'package:gamengine/src/render/core/render_queue.dart';

class Painter extends CustomPainter {
  final RenderQueue queue;
  final Paint _spritePaint = Paint();
  final Paint _circlePaint = Paint();

  final CameraState camera;

  Painter({required this.queue, CameraState? camera})
    : camera = camera ?? CameraState(),
      super(repaint: queue);

  @override
  void paint(Canvas canvas, Size size) {
    camera.viewportWidth = size.width;
    camera.viewportHeight = size.height;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(camera.zoom);
    canvas.translate(-camera.position.x, -camera.position.y);

    for (final command in queue.commands) {
      switch (command) {
        case DrawSpriteCommand():
          _drawSprite(canvas, command);
          break;
        case DrawCircleCommand():
          _drawCircle(canvas, command);
          break;
        default:
          break;
      }
    }

    canvas.restore();
  }

  void _drawSprite(Canvas canvas, DrawSpriteCommand cmd) {
    final src =
        cmd.src ??
        Rect.fromLTWH(
          0,
          0,
          cmd.image.width.toDouble(),
          cmd.image.height.toDouble(),
        );
    final w = src.width * cmd.scaleX;
    final h = src.height * cmd.scaleY;

    final ax = cmd.anchor.dx * w;
    final ay = cmd.anchor.dy * h;

    canvas.save();
    canvas.translate(cmd.position.dx, cmd.position.dy);
    canvas.rotate(cmd.rotation);

    final dst = Rect.fromLTWH(-ax, -ay, w, h);
    canvas.drawImageRect(cmd.image, src, dst, _spritePaint);

    canvas.restore();
  }

  void _drawCircle(Canvas canvas, DrawCircleCommand cmd) {
    _circlePaint.color = cmd.color;
    canvas.drawCircle(cmd.center, cmd.radius, _circlePaint);
  }

  @override
  bool shouldRepaint(covariant Painter oldDelegate) {
    return oldDelegate.camera != camera;
  }
}

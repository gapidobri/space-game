import 'dart:math' as math;

import 'package:flutter/material.dart';
import 'package:gamengine/src/systems/render/camera_state.dart';
import 'package:gamengine/src/systems/render/render_commands.dart';
import 'package:gamengine/src/systems/render/render_queue.dart';

class Painter extends CustomPainter {
  final RenderQueue queue;
  final Paint _paint = Paint();

  final CameraState camera;

  Painter({required this.queue, CameraState? camera})
    : camera = camera ?? CameraState(),
      super(repaint: queue);

  @override
  void paint(Canvas canvas, Size size) {
    camera.viewportWidth = size.width;
    camera.viewportHeight = size.height;
    final cullRect = camera.worldCullRect;

    canvas.save();
    canvas.translate(size.width / 2, size.height / 2);
    canvas.scale(camera.zoom);
    canvas.translate(-camera.position.x, -camera.position.y);

    for (final command in queue.commands) {
      switch (command) {
        case DrawSpriteCommand():
          if (!_isSpriteVisible(command, cullRect)) {
            continue;
          }
          _drawSprite(canvas, command);
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
    canvas.drawImageRect(cmd.image, src, dst, _paint);

    canvas.restore();
  }

  bool _isSpriteVisible(DrawSpriteCommand cmd, Rect cullRect) {
    return _spriteBounds(cmd).overlaps(cullRect);
  }

  Rect _spriteBounds(DrawSpriteCommand cmd) {
    final src =
        cmd.src ??
        Rect.fromLTWH(
          0,
          0,
          cmd.image.width.toDouble(),
          cmd.image.height.toDouble(),
        );

    final width = src.width * cmd.scaleX.abs();
    final height = src.height * cmd.scaleY.abs();

    if (width == 0 || height == 0) {
      return Rect.fromLTWH(cmd.position.dx, cmd.position.dy, 0, 0);
    }

    final localCenterX = (0.5 - cmd.anchor.dx) * width;
    final localCenterY = (0.5 - cmd.anchor.dy) * height;

    final cosR = math.cos(cmd.rotation);
    final sinR = math.sin(cmd.rotation);

    final centerX =
        cmd.position.dx + (localCenterX * cosR) - (localCenterY * sinR);
    final centerY =
        cmd.position.dy + (localCenterX * sinR) + (localCenterY * cosR);

    final halfW = width * 0.5;
    final halfH = height * 0.5;

    final aabbHalfW = (halfW * cosR.abs()) + (halfH * sinR.abs());
    final aabbHalfH = (halfW * sinR.abs()) + (halfH * cosR.abs());

    return Rect.fromLTRB(
      centerX - aabbHalfW,
      centerY - aabbHalfH,
      centerX + aabbHalfW,
      centerY + aabbHalfH,
    );
  }

  @override
  bool shouldRepaint(covariant Painter oldDelegate) {
    return oldDelegate.camera != camera;
  }
}

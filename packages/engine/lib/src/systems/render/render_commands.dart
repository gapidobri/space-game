import 'dart:ui';

abstract class RenderCommand {
  RenderCommand({this.z = 0});

  final int z;
}

class DrawSpriteCommand extends RenderCommand {
  final Image image;
  final Rect? src;
  final Offset position;
  final double rotation;
  final double scaleX;
  final double scaleY;
  final Offset anchor;

  DrawSpriteCommand({
    required this.image,
    required this.position,
    this.src,
    this.rotation = 0,
    this.scaleX = 0,
    this.scaleY = 0,
    this.anchor = const Offset(0.5, 0.5),
    super.z = 0,
  });
}

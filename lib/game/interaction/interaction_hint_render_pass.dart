import 'package:flutter/painting.dart';
import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/interaction/interaction_target.dart';
import 'package:space_game/game/rocket/components/eva.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';

class InteractionHintRenderPass extends RenderPass {
  InteractionHintRenderPass({required this.assetManager});

  final AssetManager assetManager;

  @override
  void write(
    World world, {
    required CameraState camera,
    required RenderQueue queue,
  }) {
    final rocket = world.query<RocketTag>().firstOrNull;
    if (rocket == null) return;

    final eva = rocket.get<Eva>();

    for (final interactable in eva.interactables) {
      final transform = interactable.get<Transform>();
      final target = interactable.get<InteractionTarget>();

      queue.add(
        DrawRectangleCommand(
          rect: Rect.fromLTWH(
            transform.position.x + 110,
            transform.position.y - 30,
            125,
            60,
          ),
          paint: Paint()
            ..color = Color.fromARGB(144, 0, 0, 0)
            ..maskFilter = MaskFilter.blur(.normal, 16),
          z: 900,
        ),
      );
      queue.add(
        DrawSpriteCommand(
          image: assetManager.image('assets/keyboard.png')!.data,
          position: transform.position.toOffset() + Offset(140, 0),
          scaleX: 2,
          scaleY: 2,
          src: Rect.fromLTWH(16 * 4, 16 * 2, 16, 16),
          z: 1000,
        ),
      );
      queue.add(
        DrawTextCommand(
          text: TextSpan(
            text: target.interactionText,
            style: TextStyle(
              color: Color(0xffffffff),
              fontFamily: 'Doto',
              fontSize: 16.0,
              fontWeight: .bold,
            ),
          ),
          anchor: Offset(0, 0.5),
          position: transform.position.toOffset() + Offset(160, 0),
          z: 1000,
        ),
      );
    }
  }
}

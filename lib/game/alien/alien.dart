import 'dart:ui';

import 'package:gamengine/gamengine.dart';

class AlienTag extends Component {}

class Alien {
  static Future<Entity> create({required AssetManager assetManager}) async {
    final entity = Entity();

    entity.add(AlienTag());

    final transform = Transform();
    transform.scale = Vector2.all(2);
    entity.add(transform);

    entity.add(RigidBody());
    entity.add(CircleCollider(radius: 20));

    final atlas = await assetManager.loadImage('assets/atlas.png');
    entity.add(Sprite(image: atlas, sourceRect: Rect.fromLTWH(50, 57, 29, 17)));

    return entity;
  }
}

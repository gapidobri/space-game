import 'dart:ui';

import 'package:gamengine/gamengine.dart';

class Planet {
  static Future<Entity> create({
    required AssetManager assetManager,
    required Vector2 position,
  }) async {
    final entity = Entity();

    final transform = Transform();
    transform.position.setFrom(position);
    transform.scale = Vector2.all(10);
    entity.add(transform);

    entity.add(
      RigidBody(isStatic: true, mass: 1_000_000_000, gravityScale: 10),
    );
    entity.add(GravitySource(mass: 320000, minDistance: 250));

    entity.add(Collider(radius: 250, restitution: 0.2, staticFriction: 0.9));

    final atlas = await assetManager.loadImage('assets/atlas.png');
    entity.add(Sprite(image: atlas, sourceRect: Rect.fromLTWH(0, 0, 50, 50)));

    return entity;
  }
}

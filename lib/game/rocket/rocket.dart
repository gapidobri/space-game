import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/rocket/components/rocket_pilot.dart';

class Rocket {
  static Future<Entity> create({required AssetManager assetManager}) async {
    final entity = Entity();

    entity.add(Transform());
    entity.add(RigidBody(mass: 100));
    entity.add(Collider(radius: 20));

    final atlas = await assetManager.loadImage('assets/atlas.png');
    entity.add(Sprite(image: atlas, sourceRect: Rect.fromLTWH(0, 50, 50, 50)));

    entity.add(
      RocketPilot(thrustForce: 10000, turnSpeed: 5, boostMultiplier: 2),
    );

    return entity;
  }
}

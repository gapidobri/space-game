import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/damage/damagable.dart';
import 'package:space_game/game/mining/drill.dart';
import 'package:space_game/game/rocket/components/eva.dart';
import 'package:space_game/game/rocket/components/fuel_tank.dart';
import 'package:space_game/game/rocket/components/rocket_location.dart';
import 'package:space_game/game/rocket/components/rocket_pilot.dart';

class RocketTag extends Component {}

class RocketBuilder {
  static Future<Entity> create({required AssetManager assetManager}) async {
    final entity = Entity();
    entity.add(RocketTag());

    entity.add(Transform());
    entity.add(RigidBody(mass: 10, momentOfInertia: 200));
    entity.add(
      RectangleCollider(halfWidth: 10, halfHeight: 20, restitution: 0.2),
    );

    final atlas = await assetManager.loadImage('assets/atlas.png');
    entity.add(
      Sprite(image: atlas, sourceRect: Rect.fromLTWH(0, 50, 50, 50), z: 20),
    );

    entity.add(
      RocketPilot(thrustForce: 500, rotationForce: 1000, boostMultiplier: 2),
    );

    entity.add(FuelTank(maxFuel: 100, fuel: 100));

    entity.add(RocketLocationStore(location: RocketLocationInSpace()));
    entity.add(Eva(maxInteractionRange: 100));
    entity.add(Damagable(maxHealth: 100));
    entity.add(Drill(drillSpeed: 5));

    return entity;
  }
}

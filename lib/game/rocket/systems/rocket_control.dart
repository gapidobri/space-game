import 'dart:math' as math;

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/input.dart';
import 'package:space_game/game/rocket/components/rocket_pilot.dart';

class RocketControlSystem extends System {
  final World world;
  final InputActionState<InputAction> inputState;

  RocketControlSystem({
    super.priority,
    required this.world,
    required this.inputState,
  });

  @override
  void update(double dt) {
    final turnLeft = inputState.isPressed(InputAction.rotateLeft);
    final turnRight = inputState.isPressed(InputAction.rotateRight);
    final thrustInput = inputState.isPressed(InputAction.thrust);
    final boostInput = inputState.isPressed(InputAction.boost);

    for (final rocket in world.query2<Transform, RocketPilot>()) {
      final transform = rocket.get<Transform>();
      final rigidBody = rocket.get<RigidBody>();
      final pilot = rocket.get<RocketPilot>();

      double rotation = 0;
      if (turnLeft) {
        rotation -= 1.0;
      }
      if (turnRight) {
        rotation += 1.0;
      }
      rigidBody.angularVelocity = rotation * pilot.turnSpeed;

      final boost = boostInput ? pilot.boostMultiplier : 1;
      final thrust = thrustInput ? pilot.thrustForce * boost : 0;

      final sinR = math.sin(transform.rotation);
      final cosR = math.cos(transform.rotation);

      rigidBody.accumulatedForce.x += sinR * thrust;
      rigidBody.accumulatedForce.y += -cosR * thrust;
    }
  }
}

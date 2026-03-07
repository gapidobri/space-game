import 'dart:math' as math;

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/input.dart';
import 'package:space_game/game/rocket/components/fuel_tank.dart';
import 'package:space_game/game/rocket/components/rocket_location.dart';
import 'package:space_game/game/rocket/components/rocket_pilot.dart';

class RocketControlSystem extends System {
  RocketControlSystem({super.priority, required this.inputState});
  final InputActionState<InputAction> inputState;

  @override
  void update(double dt, World world, Commands commands) {
    final turnLeft = inputState.isPressed(.rotateLeft);
    final turnRight = inputState.isPressed(.rotateRight);
    final thrustInput = inputState.isPressed(.thrust);
    final boostInput = inputState.isPressed(.boost);

    for (final rocket in world.query<RocketPilot>()) {
      final transform = rocket.get<Transform>();
      final rigidBody = rocket.get<RigidBody>();
      final pilot = rocket.get<RocketPilot>();
      final fuelTank = rocket.get<FuelTank>();
      final rocketLocation = rocket.get<RocketLocationStore>();

      if (fuelTank.fuel <= 0) {
        continue;
      }

      if (thrustInput) {
        rocketLocation.location = RocketLocationInSpace();
      }

      double rotationForce = 0;
      if (turnLeft) {
        rotationForce -= pilot.rotationForce;
      }
      if (turnRight) {
        rotationForce += pilot.rotationForce;
      }
      rigidBody.accumulatedTorque += rotationForce;

      final boost = boostInput ? pilot.boostMultiplier : 1;
      final thrust = thrustInput ? pilot.thrustForce * boost : 0;

      final sinR = math.sin(transform.rotation);
      final cosR = math.cos(transform.rotation);

      rigidBody.accumulatedForce.x += sinR * thrust;
      rigidBody.accumulatedForce.y += -cosR * thrust;

      fuelTank.fuel -= 0.01 * thrust * dt;
    }
  }
}

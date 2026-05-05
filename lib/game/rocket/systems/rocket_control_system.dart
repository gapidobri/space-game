import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/particle_system/particle_emitter.dart';
import 'package:space_game/game/shared/input/input.dart';
import 'package:space_game/game/rocket/components/fuel_tank.dart';
import 'package:space_game/game/rocket/components/rocket_location.dart';
import 'package:space_game/game/rocket/components/rocket_engine.dart';

class RocketControlSystem extends System {
  RocketControlSystem({super.priority, required this.inputState});
  final InputActionState<InputAction> inputState;

  @override
  void update(double dt, World world, Commands commands) {
    final turnLeft = inputState.isPressed(.rotateLeft);
    final turnRight = inputState.isPressed(.rotateRight);
    final thrustInput = inputState.isPressed(.thrust);
    final boostInput = inputState.isPressed(.boost);

    for (final rocket in world.query<RocketEngine>()) {
      final transform = rocket.get<Transform>();
      final rigidBody = rocket.get<RigidBody>();
      final engine = rocket.get<RocketEngine>();
      final fuelTank = rocket.get<FuelTank>();
      final rocketLocation = rocket.get<RocketLocationStore>();
      final emitter = _getParticleEmitter(world, rocket);

      if (!engine.enabled || fuelTank.fuel <= 0) {
        emitter?.enabled = false;
        continue;
      }

      emitter?.enabled = thrustInput;

      if (thrustInput) {
        rocketLocation.location = RocketLocationInSpace();
      }

      double rotationForce = 0;
      if (turnLeft) {
        rotationForce -= engine.rotationForce;
      }
      if (turnRight) {
        rotationForce += engine.rotationForce;
      }
      rigidBody.accumulatedTorque += rotationForce;

      final boost = boostInput ? engine.boostMultiplier : 1;
      final thrust = thrustInput ? engine.thrustForce * boost : 0;

      final sinR = math.sin(transform.rotation);
      final cosR = math.cos(transform.rotation);

      rigidBody.accumulatedForce.x += sinR * thrust;
      rigidBody.accumulatedForce.y += -cosR * thrust;

      fuelTank.fuel -= 0.01 * thrust * dt;
    }
  }

  ParticleEmitter? _getParticleEmitter(World world, Entity rocket) => world
      .query2<Parent, ParticleEmitter>()
      .firstWhereOrNull((e) => e.get<Parent>().parent == rocket)
      ?.get<ParticleEmitter>();
}

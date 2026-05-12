import 'dart:math' as math;

import 'package:collection/collection.dart';
import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/particle_system/particle_emitter.dart';
import 'package:space_game/game/shared/input/input.dart';
import 'package:space_game/game/rocket/components/fuel_tank.dart';
import 'package:space_game/game/rocket/components/rocket_location.dart';
import 'package:space_game/game/rocket/components/rocket_engine.dart';
import 'package:space_game/game/rocket/components/rocket_propulsion_state.dart';

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
      final propulsion =
          rocket.tryGet<RocketPropulsionState>() ?? RocketPropulsionState();
      if (!rocket.has<RocketPropulsionState>()) {
        rocket.add(propulsion);
      }

      final canThrust = engine.enabled && fuelTank.fuel > 0;
      final thrusting = canThrust && thrustInput;
      final boosting = thrusting && boostInput;

      propulsion.thrusting = thrusting;
      propulsion.boosting = boosting;

      emitter?.enabled = thrusting;

      if (!canThrust) {
        continue;
      }

      if (thrusting) {
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

      final boost = boosting ? engine.boostMultiplier : 1;
      final thrust = thrusting ? engine.thrustForce * boost : 0;

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

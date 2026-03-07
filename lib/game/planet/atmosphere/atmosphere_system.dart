import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/planet/atmosphere/atmosphere.dart';

class AtmosphereSystem extends System {
  AtmosphereSystem();

  @override
  int get priority => 480;

  @override
  void update(double dt, World world, Commands commands) {
    for (final planet in world.query2<Transform, Atmosphere>()) {
      final pTransform = planet.get<Transform>();
      final atmosphere = planet.get<Atmosphere>();

      for (final entity in world.query<RigidBody>()) {
        final transform = entity.get<Transform>();
        final rigidBody = entity.get<RigidBody>();

        if (rigidBody.isStatic) continue;

        final distance = pTransform.position.distanceTo(transform.position);
        if (distance > atmosphere.radius) continue;

        final drag = rigidBody.velocity * -atmosphere.drag;
        final angularDrag = rigidBody.angularVelocity * -atmosphere.drag;

        rigidBody.accumulatedForce.add(drag * rigidBody.inverseMass);
        rigidBody.accumulatedTorque += angularDrag;
      }
    }
  }
}

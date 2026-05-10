import 'package:collection/collection.dart';
import 'package:flutter/animation.dart';
import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/exit_portal/exit_portal_state.dart';
import 'package:space_game/game/exit_portal/exit_portal_tag.dart';
import 'package:space_game/game/rocket/components/rocket_engine.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';

const _animationCurve = Curves.easeIn;

class ExitPortalTransitionSystem extends System {
  @override
  void update(double dt, World world, Commands commands) {
    final portal = world.query<ExitPortalTag>().firstOrNull;
    if (portal == null) return;

    final state = portal.get<ExitPortalState>();

    final portalTransform = portal.get<Transform>();

    switch (state.status) {
      case .closed:
        break;

      case .opening:
        state.openProgress += dt;
        if (state.openProgress >= 1) {
          state.openProgress = 1;
          state.status = .open;
        }
        break;

      case .open:
        break;

      case .teleporting:
        state.teleportProgress += dt;
        if (state.teleportProgress >= 1) {
          state.teleportProgress = 1;
          state.status = .closing;
        }

        final rocket = world.query<RocketTag>().firstOrNull;
        if (rocket == null) return;

        final rocketTransform = rocket.get<Transform>();
        final rigidBody = rocket.get<RigidBody>();
        rigidBody.velocity.setZero();
        rigidBody.angularVelocity = 0;

        rocket.get<RocketEngine>().enabled = false;
        state.originalRocketPosition ??= rocketTransform.position.clone();

        final delta = portalTransform.position - state.originalRocketPosition!;

        final t = _animationCurve.transform(state.teleportProgress);
        rocketTransform.position.setFrom(
          state.originalRocketPosition! + delta * state.teleportProgress,
        );
        rocketTransform.scale.setFrom(Vector2.all(2 * (1 - t)));

        break;

      case .closing:
        state.openProgress -= dt;
        if (state.openProgress <= 0) {
          state.openProgress = 0;
          state.status = .completed;
        }
        break;

      case .completed:
        break;
    }

    final t = _animationCurve.transform(state.openProgress);

    portalTransform.scale.setFrom(Vector2.all(2 * t));
  }
}

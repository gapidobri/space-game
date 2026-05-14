import 'package:flutter/animation.dart';
import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/entry_portal/entry_portal_state.dart';
import 'package:space_game/game/entry_portal/entry_portal_tag.dart';
import 'package:space_game/game/rocket/components/rocket_engine.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';
import 'package:space_game/game/run/components/run_state.dart';
import 'package:space_game/game/run/run_tag.dart';

const _animationCurve = Curves.easeIn;

class EntryPortalTransitionSystem extends System {
  @override
  void update(double dt, World world, Commands commands) {
    final portal = world.query<EntryPortalTag>().firstOrNull;
    if (portal == null) return;

    final rocket = world.query<RocketTag>().firstOrNull;
    final engine = rocket?.get<RocketEngine>();
    final rigidBody = rocket?.get<RigidBody>();

    final portalTransform = portal.get<Transform>();

    final state = portal.get<EntryPortalState>();
    switch (state.status) {
      case .initial:
        state.openProgress = 0;
        rocket?.get<Transform>().scale.setFrom(Vector2.zero());
        engine?.enabled = false;
        rigidBody?.isStatic = true;

        final run = world.query<RunTag>().first;
        if (run.get<RunState>().phase == .stagePlay) {
          state.status = .opening;
        }
        break;

      case .opening:
        state.openProgress += dt;
        if (state.openProgress >= 1) {
          state.openProgress = 1;
          state.status = .teleporting;
        }
        break;

      case .teleporting:
        engine?.enabled = false;
        state.teleportProgress += 2 * dt;
        if (state.teleportProgress >= 1) {
          state.teleportProgress = 1;
          state.status = .closing;
          engine?.enabled = true;
          rigidBody?.isStatic = false;
        }
        rocket?.get<Transform>().scale.setFrom(
          Vector2.all(2 * _animationCurve.transform(state.teleportProgress)),
        );
        break;

      case .closing:
        rocket?.get<RectangleCollider>().enabled = true;
        state.openProgress -= dt;
        if (state.openProgress <= 0) {
          state.openProgress = 0;
          state.status = .closed;
        }
        break;

      case .closed:
        break;
    }

    portalTransform.scale.setFrom(
      Vector2.all(2 * _animationCurve.transform(state.openProgress)),
    );
  }
}

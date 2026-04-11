import 'package:flutter/material.dart';
import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/hud/failure_screen.dart';
import 'package:space_game/game/hud/hud_data.dart';
import 'package:space_game/game/hud/loading_screen.dart';
import 'package:space_game/game/interaction/interaction_attempt_event.dart';
import 'package:space_game/game/rocket/rescue/rescue_attempt_event.dart';

class GameOverlay extends StatelessWidget {
  const GameOverlay({
    super.key,
    required this.hudStateStore,
    required this.eventBus,
    required this.onReset,
  });

  final HudStateStore<HudData> hudStateStore;
  final EventBus eventBus;
  final void Function() onReset;

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: hudStateStore,
      builder: (context, state, _) {
        return Stack(
          children: [
            Positioned(
              top: 16,
              left: 16,
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      [
                        'Fuel: ${state.fuel.toInt()}/${state.maxFuel.toInt()}',
                        'Health: ${state.health.toInt()}/${state.maxHealth.toInt()}',
                        'Rocket Location: ${state.rocketLocation.runtimeType}',
                        'Run Phase: ${state.runPhase}',
                        'Stage Phase: ${state.stagePhase} ',
                      ].join('\n'),
                      style: TextStyle(color: Colors.white),
                    ),
                    Text('Objectives:', style: TextStyle(color: Colors.white)),
                    for (final objective in state.objectives)
                      Text(
                        objective.name,
                        style: TextStyle(
                          color: Colors.white,
                          decoration: objective.completed
                              ? TextDecoration.lineThrough
                              : null,
                        ),
                      ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  spacing: 4.0,
                  children: [
                    Visibility(
                      visible: state.canRescue,
                      child: ElevatedButton(
                        onPressed: () => eventBus.emit(RescueAttemptEvent()),
                        child: Text('Rescue'),
                      ),
                    ),
                    for (final entity in state.minables)
                      ElevatedButton(
                        onPressed: () => eventBus.emit(
                          InteractionAttemptEvent(entity: entity),
                        ),
                        child: Text('Mine'),
                      ),
                  ],
                ),
              ),
            ),
            if (state.runPhase == .runFailed) FailureScreen(onReset: onReset),
            if (state.loading) LoadingScreen(),
          ],
        );
      },
    );
  }
}

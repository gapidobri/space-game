import 'package:flutter/material.dart';
import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/interaction/interaction_attempt_event.dart';
import 'package:space_game/game/rocket/rescue/rescue_attempt_event.dart';

class GameOverlay extends StatelessWidget {
  const GameOverlay({
    super.key,
    required this.hudStateStore,
    required this.eventBus,
  });

  final HudStateStore hudStateStore;
  final EventBus eventBus;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Positioned(
          top: 16,
          left: 16,
          child: Material(
            color: Colors.black,
            child: ValueListenableBuilder(
              valueListenable: hudStateStore,
              builder: (context, state, _) => Text(
                [
                  'Fuel: ${state.fuel.toInt()}/${state.maxFuel.toInt()}',
                  'Health: ${state.health.toInt()}/${state.maxHealth.toInt()}',
                  'Rocket Location: ${state.rocketLocation.runtimeType}',
                ].join('\n'),
                style: TextStyle(color: Colors.white),
              ),
            ),
          ),
        ),
        Align(
          alignment: Alignment.bottomCenter,
          child: Padding(
            padding: EdgeInsets.all(16.0),
            child: ValueListenableBuilder(
              valueListenable: hudStateStore,
              builder: (context, state, _) => Row(
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
        ),
      ],
    );
  }
}

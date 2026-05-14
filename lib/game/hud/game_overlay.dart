import 'package:flutter/material.dart' hide Image;
import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/hud/failure_screen.dart';
import 'package:space_game/game/hud/hud_data.dart';
import 'package:space_game/game/hud/loading_screen.dart';
import 'package:space_game/ui/widgets/gauge.dart';

const _kTextStyle = TextStyle(color: Colors.white, fontSize: 16.0);

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

  String _timerDisplay(double timer) {
    final total = timer.floor();
    final h = (total ~/ 3600).toString().padLeft(2, '0');
    final m = ((total % 3600) ~/ 60).toString().padLeft(2, '0');
    final s = (total % 60).toString().padLeft(2, '0');

    return '$h:$m:$s';
  }

  @override
  Widget build(BuildContext context) {
    return ValueListenableBuilder(
      valueListenable: hudStateStore,
      builder: (context, state, _) {
        return Stack(
          children: [
            Align(
              alignment: .topLeft,
              child: Container(
                padding: .all(16.0),
                width: 230.0,
                color: Colors.black.withValues(alpha: 0.5),
                child: Column(
                  mainAxisSize: .min,
                  crossAxisAlignment: .start,
                  children: [
                    if (state.stageIndex != null)
                      Text(
                        'Stage ${state.stageIndex}',
                        style: _kTextStyle.copyWith(
                          fontWeight: .bold,
                          fontSize: 18.0,
                        ),
                      ),
                    const SizedBox(height: 4.0),
                    if (state.runTimer != null)
                      Row(
                        children: [
                          Text('Total time', style: _kTextStyle),
                          Spacer(),
                          Text(
                            _timerDisplay(state.runTimer!),
                            style: _kTextStyle,
                          ),
                        ],
                      ),
                    if (state.stageTimer != null)
                      Row(
                        children: [
                          Text('Stage time', style: _kTextStyle),
                          Spacer(),
                          Text(
                            _timerDisplay(state.stageTimer!),
                            style: _kTextStyle,
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: .topRight,
              child: Container(
                color: Colors.black.withValues(alpha: 0.5),
                padding: .all(16.0),
                child: Column(
                  crossAxisAlignment: .start,
                  mainAxisSize: .min,
                  children: [
                    Text(
                      'Objectives',
                      style: _kTextStyle.copyWith(
                        fontSize: 24.0,
                        fontWeight: .bold,
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Required',
                      style: _kTextStyle.copyWith(fontSize: 18.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        mainAxisSize: .min,
                        crossAxisAlignment: .start,
                        children: [
                          for (final objective in state.requiredObjectives)
                            Text(
                              '${objective.name} (${objective.completed}/${objective.total})',
                              style: _kTextStyle.copyWith(
                                color: objective.completed == objective.total
                                    ? Colors.green.shade400
                                    : Colors.red.shade400,
                                fontWeight: .bold,
                              ),
                            ),
                          if (state.stagePhase == .portalReady)
                            Text(
                              'Enter the portal',
                              style: _kTextStyle.copyWith(
                                color: Colors.red.shade400,
                                fontWeight: .bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 8.0),
                    Text(
                      'Optional',
                      style: _kTextStyle.copyWith(fontSize: 18.0),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 8.0),
                      child: Column(
                        mainAxisSize: .min,
                        children: [
                          for (final objective in state.optionalObjectives)
                            Text(
                              '${objective.name} (${objective.completed}/${objective.total})',
                              style: _kTextStyle.copyWith(
                                color: objective.completed == objective.total
                                    ? Colors.green.shade400
                                    : Colors.grey,
                                fontWeight: .bold,
                              ),
                            ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: .symmetric(horizontal: 16.0, vertical: 12.0),
                width: 240.0,
                color: Colors.black.withValues(alpha: 0.5),
                child: Column(
                  mainAxisSize: .min,
                  spacing: 4.0,
                  children: [
                    Row(
                      mainAxisSize: .min,
                      children: [
                        Text('Fuel', style: _kTextStyle),
                        const Spacer(),
                        Gauge(
                          progress: state.fuel,
                          color: state.fuel < 0.3 ? Colors.red : Colors.green,
                        ),
                      ],
                    ),
                    Row(
                      mainAxisSize: .min,
                      children: [
                        Text('Health', style: _kTextStyle),
                        Spacer(),
                        Gauge(
                          progress: state.health,
                          color: state.health < 0.3 ? Colors.red : Colors.green,
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
            Opacity(
              opacity: state.loadingOverlayOpacity,
              child: LoadingScreen(),
            ),
            if (state.runPhase == .runFailed) FailureScreen(onReset: onReset),
          ],
        );
      },
    );
  }
}

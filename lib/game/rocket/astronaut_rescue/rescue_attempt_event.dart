import 'package:gamengine/gamengine.dart';

class RescueAttemptEvent extends GameEvent {
  const RescueAttemptEvent({required this.astronaut});

  final Entity astronaut;
}

import 'package:gamengine/gamengine.dart';

class ObjectiveCompletedEvent extends GameEvent {
  const ObjectiveCompletedEvent({required this.objective});

  final Entity objective;
}

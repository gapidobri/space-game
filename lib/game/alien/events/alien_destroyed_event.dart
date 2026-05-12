import 'package:gamengine/ecs.dart';

class AlienDestroyedEvent extends GameEvent {
  const AlienDestroyedEvent({required this.alien});

  final Entity alien;
}

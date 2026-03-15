import 'package:gamengine/ecs.dart';

class InteractionAttemptEvent extends GameEvent {
  const InteractionAttemptEvent({required this.entity});

  final Entity entity;
}

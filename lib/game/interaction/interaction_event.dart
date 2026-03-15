import 'package:gamengine/ecs.dart';

class InteractionEvent extends GameEvent {
  const InteractionEvent({required this.entity});

  final Entity entity;
}

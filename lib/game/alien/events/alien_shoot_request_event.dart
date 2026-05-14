import 'package:gamengine/gamengine.dart';

class AlienShootRequestEvent extends GameEvent {
  const AlienShootRequestEvent({required this.alien});

  final Entity alien;
}

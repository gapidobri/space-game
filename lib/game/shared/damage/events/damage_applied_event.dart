import 'package:gamengine/ecs.dart';

class DamageAppliedEvent extends GameEvent {
  const DamageAppliedEvent({
    required this.target,
    required this.source,
    required this.amount,
    required this.relativeSpeed,
  });

  final Entity target;
  final Entity source;
  final double amount;
  final double relativeSpeed;
}

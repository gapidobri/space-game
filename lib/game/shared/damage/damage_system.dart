import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/shared/damage/health.dart';
import 'package:space_game/game/shared/damage/damage_dealer.dart';
import 'package:space_game/game/shared/damage/events/damage_applied_event.dart';

class DamageSystem extends System {
  DamageSystem({super.priority, required this.eventBus});

  final EventBus eventBus;

  @override
  void update(double dt, World world, Commands commands) {
    for (final event in eventBus.read<CollisionEvent>()) {
      _damage(
        damagableEntity: event.entityA,
        damageDealerEntity: event.entityB,
        relativeSpeed: event.relativeSpeed,
        commands: commands,
      );
      _damage(
        damagableEntity: event.entityB,
        damageDealerEntity: event.entityA,
        relativeSpeed: event.relativeSpeed,
        commands: commands,
      );
    }
  }

  void _damage({
    required Entity damagableEntity,
    required Entity damageDealerEntity,
    required double relativeSpeed,
    required Commands commands,
  }) {
    final health = damagableEntity.tryGet<Health>();

    if (health == null) return;

    double? applied;
    if (damageDealerEntity.has<ConstantDamageDealer>()) {
      final damageDealer = damageDealerEntity.get<ConstantDamageDealer>();
      applied = damageDealer.damage;
    } else if (damageDealerEntity.has<VelocityDamageDealer>()) {
      final damageDealer = damageDealerEntity.get<VelocityDamageDealer>();
      if (relativeSpeed < damageDealer.minVelocity) return;
      applied = relativeSpeed * damageDealer.damageMultiplier;

      if (damageDealer.destroyOnCollision) {
        commands.despawn(damageDealerEntity);
      }
    }

    if (applied == null || applied <= 0) return;

    health.currentHealth -= applied;
    eventBus.emit(
      DamageAppliedEvent(
        target: damagableEntity,
        source: damageDealerEntity,
        amount: applied,
        relativeSpeed: relativeSpeed,
      ),
    );
  }
}

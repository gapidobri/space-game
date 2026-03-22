import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/shared/damage/health.dart';
import 'package:space_game/game/shared/damage/damage_dealer.dart';

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
      );
      _damage(
        damagableEntity: event.entityB,
        damageDealerEntity: event.entityA,
        relativeSpeed: event.relativeSpeed,
      );
    }
  }

  void _damage({
    required Entity damagableEntity,
    required Entity damageDealerEntity,
    required double relativeSpeed,
  }) {
    final health = damagableEntity.tryGet<Health>();

    if (health == null) return;

    if (damageDealerEntity.has<ConstantDamageDealer>()) {
      final damageDealer = damageDealerEntity.get<ConstantDamageDealer>();
      health.currentHealth -= damageDealer.damage;
    } else if (damageDealerEntity.has<VelocityDamageDealer>()) {
      final damageDealer = damageDealerEntity.get<VelocityDamageDealer>();
      if (relativeSpeed < damageDealer.minVelocity) return;
      health.currentHealth -= relativeSpeed * damageDealer.damageMultiplier;
    }
  }
}

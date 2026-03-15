import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/damage/damagable.dart';
import 'package:space_game/game/damage/damage_dealer.dart';

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
    final damagable = damagableEntity.tryGet<Damagable>();

    if (damagable == null) return;

    if (damageDealerEntity.has<ConstantDamageDealer>()) {
      final damageDealer = damageDealerEntity.get<ConstantDamageDealer>();
      damagable.health -= damageDealer.damage;
    } else if (damageDealerEntity.has<VelocityDamageDealer>()) {
      final damageDealer = damageDealerEntity.get<VelocityDamageDealer>();
      if (relativeSpeed < damageDealer.minVelocity) return;
      damagable.health -= relativeSpeed * damageDealer.damageMultiplier;
    }
  }
}

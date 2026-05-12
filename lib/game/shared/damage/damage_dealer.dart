import 'package:gamengine/gamengine.dart';

class ConstantDamageDealer extends Component {
  ConstantDamageDealer({required this.damage, this.destroyOnCollision = false});

  double damage;
  bool destroyOnCollision;
}

class VelocityDamageDealer extends Component {
  VelocityDamageDealer({
    this.damageMultiplier = 1,
    this.minVelocity = 30,
    this.destroyOnCollision = false,
  });

  double damageMultiplier;
  double minVelocity;
  bool destroyOnCollision;
}

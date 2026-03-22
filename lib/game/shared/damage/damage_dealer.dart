import 'package:gamengine/gamengine.dart';

class ConstantDamageDealer extends Component {
  ConstantDamageDealer({required this.damage});

  double damage;
}

class VelocityDamageDealer extends Component {
  VelocityDamageDealer({this.damageMultiplier = 1, this.minVelocity = 30});

  double damageMultiplier;
  double minVelocity;
}

import 'dart:math' as math;

import 'package:gamengine/gamengine.dart';

class Damagable extends Component {
  Damagable({required this.maxHealth, double? health})
    : _health = health ?? maxHealth;

  double maxHealth;
  double _health;

  double get health => _health;

  set health(double value) => _health = math.max(0, math.min(value, maxHealth));
}

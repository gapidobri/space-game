import 'dart:math' as math;

import 'package:gamengine/gamengine.dart';

class Health extends Component {
  Health({required this.maxHealth, double? currentHealth})
    : _currentHealth = currentHealth ?? maxHealth;

  double maxHealth;
  double _currentHealth;

  double get currentHealth => _currentHealth;
  double get percentage => _currentHealth / maxHealth;

  set currentHealth(double value) =>
      _currentHealth = math.max(0, math.min(value, maxHealth));
}

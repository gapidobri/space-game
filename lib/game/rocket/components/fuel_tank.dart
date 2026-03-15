import 'dart:math' as math;

import 'package:gamengine/gamengine.dart';

class FuelTank extends Component {
  FuelTank({this.maxFuel = 100, double? fuel}) : _fuel = fuel ?? maxFuel;

  double maxFuel;
  double _fuel;

  double get fuel => _fuel;

  set fuel(double value) => _fuel = math.max(0, math.min(value, maxFuel));
}

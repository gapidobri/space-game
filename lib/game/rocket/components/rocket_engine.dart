import 'package:gamengine/gamengine.dart';

class RocketEngine extends Component {
  RocketEngine({
    this.enabled = false,
    required this.thrustForce,
    required this.rotationForce,
    required this.boostMultiplier,
  });

  bool enabled;
  double thrustForce;
  double rotationForce;
  double boostMultiplier;
}

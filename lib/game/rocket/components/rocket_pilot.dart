import 'package:gamengine/gamengine.dart';

class RocketPilot extends Component {
  RocketPilot({
    required this.thrustForce,
    required this.rotationForce,
    required this.boostMultiplier,
  });

  double thrustForce;
  double rotationForce;
  double boostMultiplier;
}

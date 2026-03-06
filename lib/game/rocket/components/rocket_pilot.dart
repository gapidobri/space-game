import 'package:gamengine/gamengine.dart';

class RocketPilot extends Component {
  final double thrustForce;
  final double rotationForce;
  final double boostMultiplier;

  RocketPilot({
    required this.thrustForce,
    required this.rotationForce,
    required this.boostMultiplier,
  });
}

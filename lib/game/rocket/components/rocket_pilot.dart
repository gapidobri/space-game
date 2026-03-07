import 'package:gamengine/gamengine.dart';

class RocketPilot extends Component {

  RocketPilot({
    required this.thrustForce,
    required this.rotationForce,
    required this.boostMultiplier,
  });
  final double thrustForce;
  final double rotationForce;
  final double boostMultiplier;
}

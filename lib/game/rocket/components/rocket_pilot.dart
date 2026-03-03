import 'package:gamengine/gamengine.dart';

class RocketPilot extends Component {
  final double thrustForce;
  final double turnSpeed;
  final double boostMultiplier;

  RocketPilot({
    required this.thrustForce,
    required this.turnSpeed,
    required this.boostMultiplier,
  });
}

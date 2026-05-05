import 'package:gamengine/gamengine.dart';

class Particle extends Component {
  Particle({
    required this.lifetime,
    double? initialLifetime,
    this.fadeOutTime = 0,
  }) : initialLifetime = initialLifetime ?? lifetime;

  double initialLifetime;
  double lifetime;
  double fadeOutTime;
}

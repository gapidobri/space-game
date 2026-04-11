import 'package:gamengine/gamengine.dart';

class Particle extends Component {
  Particle({required this.lifetime, this.fadeOutTime = 0})
    : initialLifetime = lifetime;

  double initialLifetime;
  double lifetime;
  double fadeOutTime;
}

import 'package:gamengine/gamengine.dart';

class AstronautLocationStore extends Component {
  AstronautLocationStore({required this.location});

  AstronautLocation location;
}

sealed class AstronautLocation {
  const AstronautLocation();
}

class AstronautLocationOnPlanet implements AstronautLocation {
  const AstronautLocationOnPlanet({required this.planet, required this.angle});

  final Entity planet;
  final double angle;
}

class AstronautLocationInRocket implements AstronautLocation {}

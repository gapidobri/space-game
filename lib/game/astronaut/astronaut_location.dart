import 'package:gamengine/gamengine.dart';

class AstronautLocation extends Component {
  AstronautLocation({required this.type});

  AstronautLocationType type;
}

sealed class AstronautLocationType {
  const AstronautLocationType();
}

class AstronautLocationOnPlanet implements AstronautLocationType {
  const AstronautLocationOnPlanet({required this.planet, required this.angle});

  final Entity planet;
  final double angle;
}

class AstronautLocationInRocket implements AstronautLocationType {}

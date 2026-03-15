import 'package:gamengine/gamengine.dart';

class PlanetOccupant extends Component {
  PlanetOccupant({required this.planet, required this.angle});

  Entity planet;
  double angle;
}

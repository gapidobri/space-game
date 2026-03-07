import 'package:gamengine/gamengine.dart';

class RocketLocationStore extends Component {
  RocketLocationStore({required this.location});

  RocketLocation location;
}

sealed class RocketLocation {
  const RocketLocation();
}

class RocketLocationInSpace extends RocketLocation {
  const RocketLocationInSpace();
}

class RocketLocationLanded extends RocketLocation {
  const RocketLocationLanded({required this.planet});

  final Entity planet;
}

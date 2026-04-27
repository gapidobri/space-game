import 'package:gamengine/gamengine.dart';

enum PortalStatus { closed, opening, open, teleporting, closing, completed }

class PortalState extends Component {
  PortalState({
    this.status = .closed,
    this.openProgress = 0,
    this.teleportProgress = 0,
  });

  PortalStatus status;
  double openProgress;
  double teleportProgress;
  Vector2? originalRocketPosition;
}

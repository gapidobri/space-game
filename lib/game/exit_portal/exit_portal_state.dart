import 'package:gamengine/gamengine.dart';

enum ExitPortalStatus { closed, opening, open, teleporting, closing, completed }

class ExitPortalState extends Component {
  ExitPortalState({
    this.status = .closed,
    this.openProgress = 0,
    this.teleportProgress = 0,
  });

  ExitPortalStatus status;
  double openProgress;
  double teleportProgress;
  Vector2? originalRocketPosition;
}

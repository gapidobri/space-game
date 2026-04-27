import 'package:gamengine/gamengine.dart';

enum EntryPortalStatus { opening, teleporting, closing, closed }

class EntryPortalState extends Component {
  EntryPortalState({
    this.status = .opening,
    this.openProgress = 0,
    this.teleportProgress = 0,
  });

  EntryPortalStatus status;
  double openProgress;
  double teleportProgress;
}

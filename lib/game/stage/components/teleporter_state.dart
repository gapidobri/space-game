import 'package:gamengine/gamengine.dart';

class TeleporterState extends Component {
  TeleporterState({
    required this.requiredParts,
    this.collectedParts = 0,
    this.activated = false,
    this.exitEventComplete = false,
  });

  int requiredParts;
  int collectedParts;
  bool activated;
  bool exitEventComplete;

  bool get isReady => collectedParts >= requiredParts;
}

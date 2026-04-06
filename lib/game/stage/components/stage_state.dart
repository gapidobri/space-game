import 'package:gamengine/gamengine.dart';

enum StagePhase { briefing, exploring, portalReady, portalActivating, leaving }

class StageState extends Component {
  StageState({required this.phase});

  StagePhase phase;
}

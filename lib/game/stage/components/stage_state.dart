import 'package:gamengine/gamengine.dart';

enum StagePhase { briefing, exploring, portalReady, leaving }

class StageState extends Component {
  StageState({this.phase = .briefing, this.timer = 0.0});

  StagePhase phase;
  double timer;
}

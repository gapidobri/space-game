import 'package:gamengine/gamengine.dart';

enum RunPhase {
  runStart,
  stageSetup,
  stageEnter,
  stagePlay,
  stageExit,
  stageTransition,
  finalBoss,
  runComplete,
  runFailed,
}

class RunState extends Component {
  RunState({this.phase = .runStart, this.stageIndex = 1, this.timer = 0.0});

  RunPhase phase;
  int stageIndex;
  double timer;
}

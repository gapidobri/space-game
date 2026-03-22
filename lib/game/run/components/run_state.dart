import 'package:gamengine/gamengine.dart';

enum RunPhase {
  runStart,
  stageEnter,
  stagePlay,
  stageExit,
  stageTransition,
  finalBoss,
  runComplete,
  runFailed,
}

class RunState extends Component {
  RunState({required this.phase, this.stageIndex = 1});

  RunPhase phase;
  int stageIndex;
}

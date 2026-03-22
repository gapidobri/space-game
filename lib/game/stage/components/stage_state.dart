import 'package:gamengine/gamengine.dart';

enum StagePhase {
  briefing,
  exploring,
  teleporterReady,
  teleporterActivating,
  leaving,
}

class StageState extends Component {
  StageState({required this.phase});

  StagePhase phase;
}

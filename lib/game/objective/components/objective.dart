import 'package:gamengine/gamengine.dart';

enum ObjectiveKind { rescue, mine }

enum ObjectiveTier { required, optional }

class Objective extends Component {
  Objective({required this.kind, required this.tier, this.completed = false});

  ObjectiveKind kind;
  ObjectiveTier tier;
  bool completed;
}

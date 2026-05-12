import 'package:gamengine/gamengine.dart';

enum AlienDestructionStatus { alive, destroying, dead }

class AlienDestructionState extends Component {
  AlienDestructionState({this.status = .alive});

  AlienDestructionStatus status;
}

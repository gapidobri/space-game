import 'package:gamengine/gamengine.dart';

class RocketPropulsionState extends Component {
  RocketPropulsionState({this.thrusting = false, this.boosting = false});

  bool thrusting;
  bool boosting;
}

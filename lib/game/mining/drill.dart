import 'package:gamengine/gamengine.dart';

class Drill extends Component {
  Drill({required this.drillSpeed});

  /// Speed of the drill (unit/s)
  double drillSpeed;
  Entity? drillingResource;
}

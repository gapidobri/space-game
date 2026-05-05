import 'package:gamengine/gamengine.dart';

class Drill extends Component {
  Drill({required this.drillSpeed, this.drillingResource});

  /// Speed of the drill (unit/s)
  double drillSpeed;
  Entity? drillingResource;
}

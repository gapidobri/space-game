import 'package:gamengine/gamengine.dart';

class Atmosphere extends Component {

  Atmosphere({required this.radius, this.drag = 1.2});
  final double radius;
  final double drag;
}

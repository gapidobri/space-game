import 'package:gamengine/gamengine.dart';

class Atmosphere extends Component {
  final double radius;
  final double drag;

  Atmosphere({required this.radius, this.drag = 1.2});
}

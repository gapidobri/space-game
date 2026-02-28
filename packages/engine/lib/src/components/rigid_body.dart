import 'package:gamengine/gamengine.dart';
import 'package:vector_math/vector_math_64.dart';

class RigidBody extends Component {
  Vector2 velocity = Vector2.zero();
  double angularVelocity = 0;
}

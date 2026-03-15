import 'package:gamengine/ecs.dart';

enum ResourceType { fuel, health }

class Minable extends Component {
  Minable({required this.remaining, required this.resourceType});

  double remaining;
  ResourceType resourceType;
}

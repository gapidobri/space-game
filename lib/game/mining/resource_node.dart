import 'package:gamengine/ecs.dart';

enum ResourceType { fuel, health }

class ResourceNode extends Component {
  ResourceNode({required this.remaining, required this.resourceType});

  double remaining;
  ResourceType resourceType;
}

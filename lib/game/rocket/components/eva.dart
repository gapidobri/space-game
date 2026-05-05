import 'package:gamengine/gamengine.dart';

class Eva extends Component {
  Eva({this.maxInteractionRange = 50, Set<Entity>? interactables})
    : interactables = interactables ?? {};

  double maxInteractionRange;
  final Set<Entity> interactables;
}

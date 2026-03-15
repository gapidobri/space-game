import 'package:gamengine/gamengine.dart';

class Eva extends Component {
  Eva({this.maxInteractionRange = 50});

  double maxInteractionRange;
  final Set<Entity> interactables = {};
}

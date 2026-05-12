import 'package:gamengine/gamengine.dart';

enum AlienAnimationStatus { idle, shooting, destroying }

class AlienAnimationState extends Component {
  AlienAnimationState({this.status = .idle});

  AlienAnimationStatus status;
}

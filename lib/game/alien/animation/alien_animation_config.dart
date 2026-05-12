import 'package:gamengine/gamengine.dart';

class AnimationConfig {
  const AnimationConfig({required this.firstFrame, required this.frameCount});

  final int firstFrame;
  final int frameCount;
}

class AlienAnimationConfig extends Component {
  AlienAnimationConfig({
    required this.idleFrame,
    required this.shooting,
    required this.destruction,
  });

  final int idleFrame;
  final AnimationConfig shooting;
  final AnimationConfig destruction;
}

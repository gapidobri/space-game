import 'package:gamengine/gamengine.dart';

class BackgroundMusic extends Component {
  BackgroundMusic({
    required this.assetPath,
    this.playing = true,
    this.fadeTime = 0,
    this.fadeProgress = 0,
  });

  final String assetPath;
  bool playing;
  double fadeTime;
  double fadeProgress = 0;
}

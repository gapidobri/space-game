import 'package:gamengine/gamengine.dart';

class AudioSettings extends Component {
  AudioSettings({this.musicVolume = 1.0, this.sfxVolume = 1.0});

  double musicVolume;
  double sfxVolume;
}

import 'package:gamengine/gamengine.dart';

class AudioSettings extends Component {
  AudioSettings({
    this.musicVolume = 1.0,
    this.sfxVolume = 1.0,
    this.sfxEnabled = true,
  });

  double musicVolume;
  double sfxVolume;
  bool sfxEnabled;
}

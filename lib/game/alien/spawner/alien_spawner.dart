import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/alien_type.dart';

class AlienSpawner extends Component {
  AlienSpawner({required this.type, this.cooldown = 0.0});

  final AlienType type;

  double cooldown;
}

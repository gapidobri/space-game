import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/run/components/run_state.dart';
import 'package:space_game/game/run/run_tag.dart';

class RunTimerTickerSystem extends System {
  @override
  void update(double dt, World world, Commands commands) {
    for (final run in world.query<RunTag>()) {
      run.get<RunState>().timer += dt;
    }
  }
}

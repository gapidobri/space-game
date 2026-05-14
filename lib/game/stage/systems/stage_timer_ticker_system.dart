import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/stage/components/stage_state.dart';
import 'package:space_game/game/stage/stage_tag.dart';

class StageTimerTickerSystem extends System {
  @override
  void update(double dt, World world, Commands commands) {
    for (final stage in world.query<StageTag>()) {
      stage.get<StageState>().timer += dt;
    }
  }
}

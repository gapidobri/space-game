import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/alien/alien_state.dart';
import 'package:space_game/game/alien/alien_tag.dart';
import 'package:space_game/game/alien/animation/alien_animation_config.dart';
import 'package:space_game/game/alien/animation/alien_animation_state.dart';
import 'package:space_game/game/alien/destruction/alien_destruction_state.dart';

class AlienAnimationSystem extends System {
  @override
  int get priority => 730;

  @override
  void update(double dt, World world, Commands commands) {
    for (final alien in world.query<AlienTag>()) {
      final animatedSprite = alien.get<AnimatedSprite>();
      final animationState = alien.get<AlienAnimationState>();
      final config = alien.get<AlienAnimationConfig>();

      final state = alien.get<AlienState>();
      final destructionState = alien.get<AlienDestructionState>();

      if (destructionState.status != .alive) {
        if (animationState.status != .destroying) {
          animatedSprite
            ..playing = true
            ..firstFrame = config.destruction.firstFrame
            ..frameCount = config.destruction.frameCount
            ..currentFrame = 0
            ..loop = false;
          animationState.status = .destroying;
        }
        if (!animatedSprite.playing) {
          destructionState.status = .dead;
        }
        continue;
      }

      if (state.shooting) {
        if (animationState.status != .shooting) {
          animatedSprite
            ..playing = true
            ..firstFrame = config.shooting.firstFrame
            ..frameCount = config.shooting.frameCount
            ..currentFrame = 0
            ..loop = false;
          animationState.status = .shooting;
        }
        if (!animatedSprite.playing) {
          state.shooting = false;

          animatedSprite
            ..playing = false
            ..firstFrame = config.idleFrame
            ..currentFrame = 0;
          animationState.status = .idle;
        }
        continue;
      }

      if (animationState.status != .idle) {
        animatedSprite
          ..playing = false
          ..firstFrame = config.idleFrame
          ..currentFrame = 0;
        animationState.status = .idle;
      }
    }
  }
}

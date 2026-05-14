import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/interaction/interaction_target.dart';
import 'package:space_game/game/interaction/interaction_event.dart';
import 'package:space_game/game/rocket/components/eva.dart';
import 'package:space_game/game/rocket/components/rocket_location.dart';
import 'package:space_game/game/rocket/rocket_tag.dart';
import 'package:space_game/game/shared/input/input.dart';

class InteractionSystem extends System {
  InteractionSystem({super.priority, required this.eventBus});

  final EventBus eventBus;

  @override
  void update(double dt, World world, Commands commands) {
    final rocket = world.query<RocketTag>().firstOrNull;
    if (rocket == null) return;

    final rocketT = rocket.get<Transform>();
    final eva = rocket.get<Eva>();

    eva.interactables.clear();

    final rocketLocation = rocket.get<RocketLocationStore>().location;
    if (rocketLocation is! RocketLocationLanded) return;

    for (final entity in world.query<InteractionTarget>()) {
      final transform = entity.get<Transform>();

      final distance = rocketT.position.distanceTo(transform.position);

      if (distance > eva.maxInteractionRange) {
        continue;
      }

      eva.interactables.add(entity);
    }

    for (final event in eventBus.read<InputEvent<InputAction>>()) {
      if (event.action != .interact) continue;

      final interactable = eva.interactables.firstOrNull;
      if (interactable == null) continue;

      eventBus.emit(InteractionEvent(entity: interactable));
    }
  }
}

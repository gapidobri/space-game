import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/astronaut/astronaut_location.dart';
import 'package:space_game/game/interaction/interactable.dart';

class AstronautTag extends Component {}

class AstronautBuilder {
  const AstronautBuilder({required this.image, required this.location});

  final Image image;
  final AstronautLocationType location;

  AstronautBuilder copyWith({Image? image, AstronautLocationType? location}) =>
      AstronautBuilder(
        image: image ?? this.image,
        location: location ?? this.location,
      );

  Entity build() {
    final entity = Entity();
    entity.add(AstronautTag());

    entity.add(Transform()..scale = Vector2.all(2));
    entity.add(Interactable());

    entity.add(
      Sprite(image: image, sourceRect: Rect.fromLTWH(50, 50, 30, 25), z: 200),
    );

    entity.add(AstronautLocation(type: location));

    return entity;
  }
}

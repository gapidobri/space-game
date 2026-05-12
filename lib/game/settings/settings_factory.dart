import 'dart:ui';

import 'package:gamengine/gamengine.dart';
import 'package:space_game/game/settings/audio_settings.dart';

Entity createSettings() {
  final entity = Entity();

  entity.add(AudioSettings(musicVolume: 0.25));
  entity.add(
    PhysicsDebugSettings(
      enabled: false,
      linearVelocityScale: 1,
      linearAccelerationScale: 1,
      showAngularAcceleration: false,
      showAngularVelocity: false,
      angularRingPaint: PaintConfig()
        ..color = const Color(0xFFFFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 1.0,
      angularVelocityPaint: PaintConfig()
        ..color = const Color(0xFFFFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
      angularAccelerationPaint: PaintConfig()
        ..color = const Color(0xFFFFFFFF)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
      linearVelocityPaint: PaintConfig()
        ..color = const Color(0xFFFF0000)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
      linearAccelerationPaint: PaintConfig()
        ..color = const Color(0xFF00FF00)
        ..style = PaintingStyle.stroke
        ..strokeWidth = 2.0,
    ),
  );

  return entity;
}

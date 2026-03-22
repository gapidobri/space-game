import 'dart:ui';

class AtmosphereConfig {
  const AtmosphereConfig({
    required this.radius,
    required this.color,
    this.drag = 0,
    this.fuelRichness = 0,
  });

  final double radius;
  final double drag;
  final double fuelRichness;
  final Color color;
}

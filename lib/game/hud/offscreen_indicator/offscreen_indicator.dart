import 'dart:ui';

import 'package:gamengine/gamengine.dart';

class OffscreenIndicator extends Component {
  OffscreenIndicator({
    required this.image,
    this.enabled = true,
    this.scale = 1.0,
  });

  final Asset<Image> image;
  final double scale;
  bool enabled;
}

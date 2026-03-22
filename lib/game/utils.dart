import 'dart:ui';

import 'package:collection/collection.dart';
import 'package:gamengine/gamengine.dart';

extension IterableExtension<T> on Iterable<T> {
  bool containsWhere(bool Function(T) test) {
    return firstWhereOrNull(test) != null;
  }
}

extension Vector2Extension on Vector2 {
  Offset get offset => Offset(x, y);
}

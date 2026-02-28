import 'package:flutter/foundation.dart';

/// UI-facing state store fed by ECS systems.
class HudStateStore<T> extends ValueNotifier<T> {
  HudStateStore(super.value);

  void setIfChanged(T next) {
    if (value == next) {
      return;
    }
    value = next;
  }
}

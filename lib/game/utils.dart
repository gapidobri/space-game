import 'package:collection/collection.dart';

extension IterableExtension<T> on Iterable<T> {
  bool containsWhere(bool Function(T) test) {
    return firstWhereOrNull(test) != null;
  }
}

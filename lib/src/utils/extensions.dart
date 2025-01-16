extension IterableExtension<T> on Iterable<T> {
  /// Returns the first element in the iterable that satisfies the [test], or
  /// `null` if no such element is found.
  T? firstWhereOrNull(bool Function(T element) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

extension StringExtensions on String {
  /// If this [String] starts with the given [prefix], returns a copy of this
  /// string with the prefix removed. Otherwise, returns this [String].
  String removePrefix(String prefix) {
    if (startsWith(prefix)) {
      return substring(prefix.length, length);
    } else {
      return this;
    }
  }

  /// If this [String] ends with the given [suffix], returns a copy of this
  /// [String] with the suffix removed. Otherwise, returns this [String].
  String removeSuffix(String suffix) {
    if (endsWith(suffix)) {
      return substring(0, length - suffix.length);
    } else {
      return this;
    }
  }
}

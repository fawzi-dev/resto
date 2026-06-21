// Temporary ids for items we create locally before the backend assigns real
// ones. Timestamp + counter so two items in the same millisecond don't clash.
abstract final class IdGenerator {
  static int _counter = 0;

  static String next([String prefix = 'local']) {
    final stamp = DateTime.now().microsecondsSinceEpoch;
    return '${prefix}_${stamp}_${_counter++}';
  }
}

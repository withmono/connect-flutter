import 'dart:js_interop';
import 'dart:js_util' as js_util;

/// Interop with the global [MonoConnect] JavaScript object.
@JS('MonoConnect')
@staticInterop
class MonoConnect {
  external static void setup(JSAny? obj);

  external static void open();
}

/// Interop with the global [setupMonoConnect] function.
@JS('setupMonoConnect')
external void setupMonoConnect(
  String key,
  String? reference,
  String? data,
  String? accountId,
  String? scope,
);

dynamic jsToDart(Object data) {
  try {
    return js_util.dartify(data);
  } catch (e) {
    throw Exception('Unable to convert JS object to Dart: $e');
  }
}

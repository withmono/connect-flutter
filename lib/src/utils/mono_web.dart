import 'dart:js_interop';

/// Interop with the global [MonoConnect] JavaScript object.
@JS('MonoConnect')
external MonoConnectNamespace get MonoConnect;

extension type MonoConnectNamespace._(JSAny _) implements JSAny {
  external void setup(JSAny? obj);
  external void open();
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

dynamic jsToDart(JSAny? data) {
  try {
    return data?.dartify();
  } catch (e) {
    throw Exception('Unable to convert JS object to Dart: $e');
  }
}

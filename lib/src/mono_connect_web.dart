import 'dart:convert';
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:mono_connect/src/utils/mono_web.dart';
import 'package:web/web.dart' as web;

class MonoConnectWeb {
  static void registerWith(Registrar registrar) {
    final channel = MethodChannel(
      'flutter.mono.co/connect',
      const StandardMethodCodec(),
      registrar,
    );

    final pluginInstance = MonoConnectWeb();
    channel.setMethodCallHandler(
      (call) => pluginInstance.handleMethodCall(call, channel),
    );
  }

  Future<dynamic> handleMethodCall(
    MethodCall call,
    MethodChannel channel,
  ) async {
    switch (call.method) {
      case 'setup':
        void onClose() {
          channel.invokeMethod('onClose', <dynamic, dynamic>{});
        }

        void onEvent(JSString eventName, JSAny? data) {
          final dartData = jsToDart(data);
          channel.invokeMethod(
            'onEvent',
            {'eventName': eventName.toDart, 'data': jsonEncode(dartData)},
          );
        }

        void onSuccess(JSAny? data) {
          final dartData = jsToDart(data);
          channel.invokeMethod('onSuccess', jsonEncode(dartData));
        }

        web.window.setProperty('onClose'.toJS, onClose.toJS);
        web.window.setProperty('onEvent'.toJS, onEvent.toJS);
        web.window.setProperty('onSuccess'.toJS, onSuccess.toJS);
        final args = call.arguments as Map<dynamic, dynamic>;

        setupMonoConnect(
          args['key'] as String,
          args['reference'] as String?,
          args['data'] as String?,
          args['accountId'] as String?,
          args['scope'] as String?,
        );
        return null;

      case 'open':
        MonoConnect.open();
        return null;

      default:
        throw PlatformException(
          code: 'Unimplemented',
          details: "connect for web doesn't implement '${call.method}'",
        );
    }
  }

  Future<String> getPlatformVersion() {
    final version = web.window.navigator.userAgent;
    return Future.value(version);
  }
}

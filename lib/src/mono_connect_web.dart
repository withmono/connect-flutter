import 'dart:convert';
import 'dart:html' as html show window;
import 'dart:js' show allowInterop;
import 'dart:js_util' as js_util;

import 'package:flutter/services.dart';
import 'package:flutter_web_plugins/flutter_web_plugins.dart';
import 'package:mono_connect/src/utils/mono_web.dart';

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

        void onEvent(String eventName, Object data) {
          final dartData = jsToDart(data);
          channel.invokeMethod(
            'onEvent',
            {'eventName': eventName, 'data': jsonEncode(dartData)},
          );
        }

        void onSuccess(Object data) {
          final dartData = jsToDart(data);
          channel.invokeMethod('onSuccess', jsonEncode(dartData));
        }

        js_util.setProperty(html.window, 'onClose', allowInterop(onClose));
        js_util.setProperty(html.window, 'onEvent', allowInterop(onEvent));
        js_util.setProperty(html.window, 'onSuccess', allowInterop(onSuccess));

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
    final version = html.window.navigator.userAgent;
    return Future.value(version);
  }
}

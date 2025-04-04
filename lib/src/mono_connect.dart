import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mono_connect/src/connect_web_view.dart';
import 'package:mono_connect/src/models/models.dart';
import 'package:mono_connect/src/utils/constants.dart';

/// The Mono Connect SDK is a quick and secure way to link bank accounts to Mono from within your Flutter app.
/// Mono Connect is a drop-in framework that handles connecting a financial institution to your app
/// (credential validation, multi-factor authentication, error handling, etc).
///
/// This class serves as the entry point for interacting with the Mono Connect SDK in Flutter,
/// offering multiple ways to present the Mono Connect WebView widget to users.
class MonoConnect {
  static MethodChannel channel = const MethodChannel('flutter.mono.co/connect');

  /// Returns the Mono Connect WebView widget configured with the provided [ConnectConfiguration].
  ///
  /// This method is used to initialize and return the `ConnectWebView` widget with the specified
  /// [config] and optional [showLogs] parameter. The `ConnectWebView` widget is only available
  /// on non-web platforms.
  static Widget _webView(
    ConnectConfiguration config, {
    bool shouldReauthorise = false,
    bool showLogs = false,
  }) {
    return ConnectWebView.config(
      config: config.copyWith(
        scope: _resolveScope(
          config.scope,
          shouldReauthorise: shouldReauthorise,
        ),
      ),
      showLogs: showLogs,
    );
  }

  static void _open(ConnectConfiguration config) {
    final customerJson = {'customer': config.customer.toMap()};
    final json = {
      if (config.extras != null) ...config.extras!,
      ...customerJson,
    };

    String? institution;
    if (config.selectedInstitution != null) {
      institution = config.selectedInstitution!.toJson();
    }

    channel
      ..invokeMethod('setup', {
        'key': config.publicKey,
        'version': Constants.version,
        'scope': config.scope ?? Constants.authScope,
        'data': jsonEncode(json),
        if (config.accountId != null) 'account': config.accountId,
        if (config.reference != null) 'reference': config.reference,
        if (institution != null) 'selectedInstitution': institution,
      })
      ..setMethodCallHandler((call) async {
        switch (call.method) {
          case 'onClose':
            config.onClose?.call();

            return true;
          case 'onSuccess':
            final args = (jsonDecode(call.arguments.toString())
                    as Map<Object?, Object?>)
                .map<String, Object?>((key, value) => MapEntry('$key', value));

            config.onSuccess(args['code'].toString());

            return true;
          case 'onEvent':
            if (config.onEvent != null) {
              final args = (call.arguments as Map<Object?, Object?>)
                  .map<String, Object?>(
                (key, value) => MapEntry('$key', value),
              );

              final data = {
                ...(jsonDecode(args['data'].toString())
                    as Map<String, dynamic>),
                'type': args['eventName'],
              };

              config.onEvent!(ConnectEvent.fromMap({...args, 'data': data}));
            }
            return true;
        }
      });
  }

  /// Launches the Mono Connect WebView widget in a new full-screen page.
  ///
  /// It requires a [BuildContext] and a [ConnectConfiguration] instance
  /// to initialize the WebView.
  ///
  /// ### Parameters:
  /// - [context]: The `BuildContext` used to access the navigation stack.
  /// - [config]: A required [ConnectConfiguration] instance for configuring the Mono Connect session.
  /// - [showLogs]: (Optional) A boolean flag to enable or disable logging. Default is `false`.
  ///
  /// ### Example:
  /// ```dart
  /// final config = ConnectConfiguration(
  ///   sessionId: 'your-session-id',
  ///   onSuccess: () => print('Success!'),
  /// );
  ///
  /// MonoConnect.launch(context, config: config);
  /// ```
  static void launch(
    BuildContext context, {
    required ConnectConfiguration config,
    bool shouldReauthorise = false,
    bool showLogs = false,
  }) {
    assert(
      (config.accountId != null) == shouldReauthorise,
      'Invalid state: accountId must not be null if shouldReauthorise is true, and must be null otherwise.',
    );

    if (kIsWeb) {
      return _open(
        config.copyWith(
          scope: _resolveScope(
            config.scope,
            shouldReauthorise: shouldReauthorise,
          ),
        ),
      );
    }

    Navigator.push(
      context,
      MaterialPageRoute<dynamic>(
        builder: (c) => _webView(
          config,
          shouldReauthorise: shouldReauthorise,
          showLogs: showLogs,
        ),
      ),
    );
  }

  /// Launches the Mono Connect WebView widget in a dialog.
  ///
  /// This method presents the WebView inside a modal dialog.
  /// Use this when you want the WebView to appear as a floating window.
  ///
  /// ### Example:
  /// ```dart
  /// MonoConnect.launchDialog(context, config: config);
  /// ```
  static void launchDialog(
    BuildContext context, {
    required ConnectConfiguration config,
    bool shouldReauthorise = false,
    bool showLogs = false,
  }) {
    assert(
      (config.accountId != null) == shouldReauthorise,
      'Invalid state: accountId must not be null if shouldReauthorise is true, and must be null otherwise.',
    );

    if (kIsWeb) {
      throw UnsupportedError('Web is not supported for this method. Please use MonoConnect.launch(context, config: config) for web.');
    }

    showDialog<dynamic>(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: _webView(
            config,
            shouldReauthorise: shouldReauthorise,
            showLogs: showLogs,
          ),
        ),
      ),
    );
  }

  /// Launches the Mono Connect WebView widget in a modal bottom sheet.
  ///
  /// This method displays the WebView inside a modal bottom sheet.
  ///
  /// ### Example:
  /// ```dart
  /// MonoConnect.launchModalBottomSheet(context, config: config);
  /// ```
  static void launchModalBottomSheet(
    BuildContext context, {
    required ConnectConfiguration config,
    bool shouldReauthorise = false,
    bool showLogs = false,
  }) {
    assert(
      (config.accountId != null) == shouldReauthorise,
      'Invalid state: accountId must not be null if shouldReauthorise is true, and must be null otherwise.',
    );

    if (kIsWeb) {
      throw UnsupportedError('Web is not supported for this method. Please use MonoConnect.launch(context, config: config) for web.');
    }

    showModalBottomSheet<dynamic>(
      context: context,
      useSafeArea: true,
      isScrollControlled: true,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(
          top: Radius.circular(24),
        ),
      ),
      clipBehavior: Clip.hardEdge,
      builder: (_) => _webView(
        config,
        shouldReauthorise: shouldReauthorise,
        showLogs: showLogs,
      ),
    );
  }

  static String? _resolveScope(
    String? scope, {
    required bool shouldReauthorise,
  }) {
    return shouldReauthorise && (scope == null || scope == Constants.authScope)
        ? Constants.reAuthScope
        : null;
  }
}

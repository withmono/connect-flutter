import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:mono_connect/src/connect_web_view.dart';
import 'package:mono_connect/src/models/connect_configuration.dart';

/// The Mono Connect SDK is a quick and secure way to link bank accounts to Mono from within your Flutter app.
/// Mono Connect is a drop-in framework that handles connecting a financial institution to your app
/// (credential validation, multi-factor authentication, error handling, etc).
///
/// This class serves as the entry point for interacting with the Mono Connect SDK in Flutter,
/// offering multiple ways to present the Mono Connect WebView widget to users.
class MonoConnect {
  /// Returns the Mono Connect WebView widget configured with the provided [ConnectConfiguration].
  ///
  /// This method is used to initialize and return the `ConnectWebView` widget with the specified
  /// [config] and optional [showLogs] parameter. The `ConnectWebView` widget is only available
  /// on non-web platforms.
  static Widget _webView(
    ConnectConfiguration config, {
    bool showLogs = false,
  }) {
    if (!kIsWeb) {
      return ConnectWebView.config(
        config: config,
        showLogs: showLogs,
      );
    }

    return const SizedBox(child: Text('Web is not supported'));
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
    bool showLogs = false,
  }) {
    Navigator.push(
      context,
      MaterialPageRoute<dynamic>(
        builder: (c) => _webView(
          config,
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
    bool showLogs = false,
  }) {
    showDialog<dynamic>(
      context: context,
      builder: (_) => Padding(
        padding: const EdgeInsets.all(24),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24),
          child: _webView(
            config,
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
    bool showLogs = false,
  }) {
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
        showLogs: showLogs,
      ),
    );
  }
}

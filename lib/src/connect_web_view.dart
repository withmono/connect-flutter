import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:mono_connect/src/models/models.dart';
import 'package:mono_connect/src/utils/constants.dart';
import 'package:mono_connect/src/utils/extensions.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'package:webview_flutter_wkwebview/webview_flutter_wkwebview.dart';

const _loggerName = 'MonoConnectWidgetLogger';

/// This widget provides the interface for managing user account
/// linking via Mono Connect.
class ConnectWebView extends StatefulWidget {
  /// Creates a [ConnectWebView] instance for integrating Mono Connect within the application.
  const ConnectWebView({
    required this.publicKey,
    required this.onSuccess,
    required this.customer,
    this.scope = Constants.authScope,
    this.showLogs = false,
    super.key,
    this.reference,
    this.accountId,
    this.onEvent,
    this.onClose,
    this.selectedInstitution,
    this.extras,
  });

  /// Creates a [ConnectWebView] instance from a [ConnectConfiguration] config
  /// for integrating Mono Connect within the application
  ConnectWebView.config({
    required ConnectConfiguration config,
    this.showLogs = false,
    super.key,
  })  : publicKey = config.publicKey,
        onSuccess = config.onSuccess,
        customer = config.customer,
        scope = config.scope,
        reference = config.reference,
        accountId = config.accountId,
        onEvent = config.onEvent,
        onClose = config.onClose,
        selectedInstitution = config.selectedInstitution,
        extras = config.extras;

  /// Public key from your Mono app dashboard.
  final String publicKey;

  /// Callback triggered when account linking has been successfully completed.
  final void Function(String) onSuccess;

  /// The customer object expects the following keys based on the following conditions:
  /// New Customer: For new customers, the customer object expects the user’s name, email and identity
  /// Existing Customer: For existing customers, the customer object expects only the customer ID.
  final MonoCustomer customer;

  /// Defines the operational scope for widget initialization.
  ///
  /// Available options:
  /// `auth`
  /// `reauth`
  /// `payments`
  final String scope;

  /// An optional reference to the current instance of Mono Connect.
  /// This value will be included in all [onEvent] callbacks for tracking purposes.
  final String? reference;

  /// Account ID is returned from token exchange for a previously linked account.
  final String? accountId;

  /// Callback triggered whenever an event is dispatched by the Mono Connect widget.
  final void Function(ConnectEvent event)? onEvent;

  /// Callback triggered when the Mono Connect widget is closed.
  final VoidCallback? onClose;

  /// Allows an optional selected institution to be passed.
  final ConnectInstitution? selectedInstitution;

  /// Pass custom data to the widget initializer.
  ///
  /// ### Example:
  /// ```json
  /// {
  ///   payment_id: "PAYMENT_ID" // The `id` property returned from the Initiate Payments API.
  /// }
  /// ```
  final Map<String, dynamic>? extras;

  /// Enables or disables detailed debug logging.
  /// Defaults to `false`.
  final bool showLogs;

  @override
  State<ConnectWebView> createState() => _ConnectWebViewState();
}

class _ConnectWebViewState extends State<ConnectWebView> {
  late WebViewController _webViewController;
  ValueNotifier<bool> isLoading = ValueNotifier(true);

  final Set<Factory<OneSequenceGestureRecognizer>> gestureRecognizers = {
    Factory<TapGestureRecognizer>(
      () => TapGestureRecognizer()
        ..onTapDown = (tap) {
          SystemChannels.textInput.invokeMethod(
            'TextInput.hide',
          );
        },
    ),
    const Factory(EagerGestureRecognizer.new),
  };

  @override
  void initState() {
    super.initState();
    initializeWebview();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            WebViewWidget(
              controller: _webViewController,
              gestureRecognizers: gestureRecognizers,
            ),
            ValueListenableBuilder<bool>(
              valueListenable: isLoading,
              builder: (context, value, child) {
                if (value) {
                  return const Center(
                    child: CircularProgressIndicator.adaptive(),
                  );
                }
                return const SizedBox();
              },
            ),
          ],
        ),
      ),
    );
  }

  void initializeWebview() {
    late final PlatformWebViewControllerCreationParams params;
    params = WebViewPlatform.instance is WebKitWebViewPlatform
        ? WebKitWebViewControllerCreationParams(
            allowsInlineMediaPlayback: true,
          )
        : const PlatformWebViewControllerCreationParams();

    _webViewController = WebViewController.fromPlatformCreationParams(
      params,
      onPermissionRequest: (request) => request.grant(),
    );

    _webViewController
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..enableZoom(true)
      ..setBackgroundColor(Colors.transparent)
      ..addJavaScriptChannel(
        Constants.jsChannel,
        onMessageReceived: (JavaScriptMessage data) {
          final rawData = data.message
              .removePrefix('"')
              .removeSuffix('"')
              .replaceAll(r'\', '');
          try {
            handleResponse(rawData);
          } catch (e) {
            logger('Failed to parse message: ${data.message} \nError: $e');
          }
        },
      )
      ..setNavigationDelegate(
        NavigationDelegate(
          onPageStarted: (String url) {
            setState(() {
              isLoading.value = true;
            });
          },
          onPageFinished: (String url) {
            setState(() {
              isLoading.value = false;
            });

            if (widget.onEvent != null) {
              final event = ConnectEvent(
                type: ConnectEventType.opened,
                data: ConnectEventData(
                  eventType: Constants.OPENED_EVENT,
                  reference: widget.reference,
                  timestamp: DateTime.now(),
                ),
              );
              widget.onEvent!(event);
            }
          },
          onWebResourceError: (e) {
            setState(() {
              isLoading.value = false;
            });
            logger('WebResourceError: ${e.description}, Type: ${e.errorType}');
          },
          onNavigationRequest: (NavigationRequest request) {
            final parameters = Uri.parse(request.url).queryParameters;
            if (parameters.containsValue('cancelled') &&
                parameters.containsValue('widget_closed')) {
              return NavigationDecision.prevent;
            }
            return NavigationDecision.navigate;
          },
        ),
      );

    confirmPermissionsAndLoadUri();
  }

  Future<void> confirmPermissionsAndLoadUri() async {
    bool isCameraGranted;

    if (!kIsWeb) {
      // Request camera permission
      final cameraStatus = await Permission.camera.status;
      isCameraGranted = cameraStatus.isGranted;
    } else {
      isCameraGranted = true;
    }

    if (!isCameraGranted) {
      final result = await Permission.camera.request();

      if (result != PermissionStatus.granted) {
        const snackBar = SnackBar(
          content: Text('Permissions not granted'),
        );
        if (mounted) {
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      }
    }

    await loadRequest();
  }

  Future<void> loadRequest() {
    final customerJson = {'customer': widget.customer.toMap()};

    final json = {
      if (widget.accountId != null) 'account': widget.accountId,
      if (widget.extras != null) ...widget.extras!,
      ...customerJson,
    };
    final data = jsonEncode(json);

    String? institution;
    if (widget.selectedInstitution != null) {
      institution = widget.selectedInstitution!.toJson();
    }

    final queryParameters = {
      'key': widget.publicKey,
      'version': Constants.version,
      'scope': widget.scope,
      'data': data,
      if (widget.reference != null) 'reference': widget.reference,
      if (institution != null) 'selectedInstitution': institution,
    };

    final uri = Uri(
      scheme: Constants.urlScheme,
      host: Constants.connectHost,
      queryParameters: queryParameters,
    );

    return _webViewController.loadRequest(uri);
  }

  /// parse event from javascript channel
  void handleResponse(String body) {
    try {
      final bodyMap = jsonDecode(body) as Map<String, dynamic>;
      final type = bodyMap['type'] as String?;
      final data = bodyMap['data'] as Map<String, dynamic>? ?? {};

      if (widget.onEvent != null) {
        final event = ConnectEvent.fromMap(bodyMap);

        if (!event.type.isDeprecated) {
          widget.onEvent!(event);
        }
      }

      if (type != null) {
        switch (type) {
          case 'mono.connect.widget.account_linked':
            final code = data['code'] as String? ?? '';
            Navigator.pop(context);
            widget.onSuccess.call(code);
          case 'mono.connect.widget.closed':
            Navigator.pop(context);
            if (mounted && widget.onClose != null) widget.onClose?.call();
        }
      }
    } catch (e) {
      logger('$_loggerName: Failed to parse message: $body \nError: $e');
    }
  }

  void logger(String log) {
    if (kDebugMode && widget.showLogs) {
      debugPrint('$_loggerName: $log');
    }
  }
}

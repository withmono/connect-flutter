import 'package:flutter/foundation.dart';
import 'package:mono_connect/src/models/connect_event.dart';
import 'package:mono_connect/src/models/connect_institution.dart';
import 'package:mono_connect/src/models/mono_customer.dart';
import 'package:mono_connect/src/utils/constants.dart';

class ConnectConfiguration {
  ConnectConfiguration({
    required this.publicKey,
    required this.onSuccess,
    required this.customer,
    this.scope = Constants.authScope,
    this.reference,
    this.accountId,
    this.onClose,
    this.onEvent,
    this.selectedInstitution,
    this.extras,
  });

  /// Public key from your Mono app dashboard.
  final String publicKey;

  /// Callback triggered when account linking has been successfully completed.
  final void Function(String) onSuccess;

  /// The customer object expects the following keys based on the following conditions:
  /// New Customer: For new customers, the customer object expects the user’s name, email and identity
  /// Existing Customer: For existing customers, the customer object expects only the customer ID.
  final MonoCustomer customer;

  /// The scope for the widget initialisation. Options: auth, reauth, payments
  final String scope;

  /// An optional reference to the current instance of Mono Connect.
  /// This value will be included in all [onEvent] callbacks for tracking purposes.
  final String? reference;

  /// Account ID is returned from token exchange for a previously linked account.
  final String? accountId;

  /// Callback triggered when the Mono Connect widget is closed.
  final VoidCallback? onClose;

  /// Callback triggered whenever an event is dispatched by the Mono Connect widget.
  final void Function(ConnectEvent)? onEvent;

  /// An optional [ConnectInstitution] object that opens the widget directly on the institution passed
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

  ConnectConfiguration copyWith({
    String? scope,
    String? reference,
    String? accountId,
    VoidCallback? onClose,
    void Function(ConnectEvent)? onEvent,
    ConnectInstitution? selectedInstitution,
    Map<String, dynamic>? extras,
  }) {
    return ConnectConfiguration(
      publicKey: publicKey,
      onSuccess: onSuccess,
      customer: customer,
      scope: scope ?? this.scope,
      reference: reference ?? this.reference,
      accountId: accountId ?? this.accountId,
      onClose: onClose ?? this.onClose,
      onEvent: onEvent ?? this.onEvent,
      selectedInstitution: selectedInstitution ?? this.selectedInstitution,
      extras: extras ?? this.extras,
    );
  }
}

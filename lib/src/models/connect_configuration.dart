import 'package:flutter/foundation.dart';
import 'package:mono_connect/src/models/connect_event.dart';
import 'package:mono_connect/src/models/connect_institution.dart';
import 'package:mono_connect/src/models/mono_customer.dart';

class ConnectConfiguration {
  ConnectConfiguration({
    required this.publicKey,
    required this.onSuccess,
    required this.customer,
    this.reference,
    this.reauthCode,
    this.onClose,
    this.onEvent,
    this.selectedInstitution,
  });

  /// Public key from your Mono app dashboard.
  final String publicKey;

  /// Callback triggered when account linking has been successfully completed.
  final void Function(String) onSuccess;

  /// The customer object expects the following keys based on the following conditions:
  /// New Customer: For new customers, the customer object expects the user’s name, email and identity
  /// Existing Customer: For existing customers, the customer object expects only the customer ID.
  final MonoCustomer customer;

  /// An optional reference to the current instance of Mono Connect.
  /// This value will be included in all [onEvent] callbacks for tracking purposes.
  final String? reference;

  /// Re-auth token received from re-authentication endpoint
  final String? reauthCode;

  /// Callback triggered when the Mono Connect widget is closed.
  final VoidCallback? onClose;

  /// Callback triggered whenever an event is dispatched by the Mono Connect widget.
  final void Function(ConnectEvent)? onEvent;

  /// An optional [ConnectInstitution] object that opens the widget directly on the institution passed
  final ConnectInstitution? selectedInstitution;

  ConnectConfiguration copyWith({
    String? reference,
    String? reauthCode,
    VoidCallback? onClose,
    void Function(ConnectEvent)? onEvent,
    ConnectInstitution? selectedInstitution,
  }) {
    return ConnectConfiguration(
      publicKey: publicKey,
      onSuccess: onSuccess,
      customer: customer,
      reference: reference ?? this.reference,
      reauthCode: reauthCode ?? this.reauthCode,
      onClose: onClose ?? this.onClose,
      onEvent: onEvent ?? this.onEvent,
      selectedInstitution: selectedInstitution ?? this.selectedInstitution,
    );
  }
}

import 'package:mono_connect/src/utils/constants.dart';
import 'package:mono_connect/src/utils/extensions.dart';

/// Event types dispatched by the Mono Connect Widget.
enum ConnectEventType {
  /// Triggered when the user opens the Connect Widget.
  /// Event value: ["mono.connect.widget_opened"].
  opened(Constants.OPENED_EVENT),

  /// Triggered when the widget reports an error.
  /// Event value: ["mono.connect.error_occured"].
  error(Constants.ERROR_EVENT),

  /// Triggered when an institution is selected.
  /// Event value: ["mono.connect.institution_selected"].
  institutionSelected(Constants.INSTITUTION_SELECTED_EVENT),

  /// Triggered when the authentications method is switched.
  /// Event value: ["mono.connect.auth_method_switched"].
  authMethodSwitched(Constants.AUTH_METHOD_SWITCHED_EVENT),

  /// Triggered when the user exits the widget.
  /// Event value: ["mono.connect.on_exit"].
  exit(Constants.EXIT_EVENT),

  /// Triggered on a login attempt from the user.
  /// Event value: ["mono.connect.login_attempt"].
  submitCredentials(Constants.SUBMIT_CREDENTIALS_EVENT),

  /// Event value: ["mono.connect.mfa_submitted"].
  submitMFA(Constants.SUBMIT_MFA_EVENT),

  /// Triggered when account linking has been successfully completed.
  /// Event value: ["mono.connect.account_linked"].
  accountLinked(Constants.ACCOUNT_LINKED_EVENT),

  /// Event value: ["mono.connect.account_selected"].
  accountSelected(Constants.ACCOUNT_SELECTED_EVENT),

  /// Event value: ["mono.connect.widget.closed"].
  widgetClosed(Constants.WIDGET_CLOSED_EVENT, 1),

  /// Event value: ["mono.connect.widget.account_linked"].
  widgetAccountLinked(Constants.WIDGET_ACCOUNT_LINKED_EVENT, 1),

  /// Event value: ["mono.modal.closed"].
  modalClosed(Constants.MODAL_CLOSED_EVENT, 1),

  /// Event value: ["mono.modal.linked"].
  modalLinkedEvent(Constants.MODAL_LINKED_EVENT, 1),

  /// Represents an unexpected or unknown event.
  /// Event value: [Constants.UNKNOWN].
  unknown(Constants.UNKNOWN);

  const ConnectEventType(this.value, [this.deprecated = 0]);

  /// The string representation of the event type.
  final String value;

  /// Whether the event has been deprecated and should not be consumed.
  /// `0` if false
  /// `1` if true
  final int deprecated;

  /// Converts a string value to a corresponding [ConnectEventType].
  ///
  /// If the value does not match any known [ConnectEventType],
  /// [ConnectEventType.unknown] is returned.
  static ConnectEventType fromValue(String value) {
    final type =
        ConnectEventType.values.firstWhereOrNull((e) => e.value == value);

    return type ?? ConnectEventType.unknown;
  }

  bool get isDeprecated => deprecated == 1;
}

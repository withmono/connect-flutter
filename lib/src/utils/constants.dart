// ignore_for_file: constant_identifier_names

class Constants {
  Constants._();

  static const String urlScheme = 'https';

  static const String connectHost = 'connect.mono.co';

  static const String version = '2023-12-14';

  static const String scope = 'auth';

  static const String jsChannel = 'MonoClientInterface';

  // Events
  static const String OPENED_EVENT = 'mono.connect.widget_opened';
  static const String ERROR_EVENT = 'mono.connect.error_occured';
  static const String INSTITUTION_SELECTED_EVENT = 'mono.connect.institution_selected';
  static const String AUTH_METHOD_SWITCHED_EVENT = 'mono.connect.auth_method_switched';
  static const String EXIT_EVENT = 'mono.connect.on_exit';
  static const String SUBMIT_CREDENTIALS_EVENT = 'mono.connect.login_attempt';
  static const String SUBMIT_MFA_EVENT = 'mono.connect.mfa_submitted';
  static const String ACCOUNT_LINKED_EVENT = 'mono.connect.account_linked';
  static const String ACCOUNT_SELECTED_EVENT = 'mono.connect.account_selected';
  static const String UNKNOWN = 'UNKNOWN';

  // Deprecated Events
  static const String WIDGET_CLOSED_EVENT = 'mono.connect.widget.closed';
  static const String WIDGET_ACCOUNT_LINKED_EVENT = 'mono.connect.widget.account_linked';
  static const String MODAL_CLOSED_EVENT = 'mono.modal.closed';
  static const String MODAL_LINKED_EVENT = 'mono.modal.linked';
}

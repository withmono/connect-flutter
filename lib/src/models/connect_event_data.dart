import 'package:equatable/equatable.dart';

class ConnectEventData extends Equatable {
  const ConnectEventData({
    required this.eventType,
    required this.timestamp,
    this.reference,
    this.pageName,
    this.prevAuthMethod,
    this.authMethod,
    this.mfaType,
    this.selectedAccountsCount,
    this.errorType,
    this.errorMessage,
    this.institutionId,
    this.institutionName,
  });

  /// Creates an [ConnectEventData] instance from a [Map].
  ///
  /// If a `timestamp` is provided, it is parsed as milliseconds since epoch.
  /// Defaults to the current time if `timestamp` is absent.
  ConnectEventData.fromMap(Map<String, dynamic> map)
      : eventType = map['type'] as String? ?? 'UNKNOWN',
        reference = map['reference'] as String?,
        pageName = map['pageName'] as String?,
        prevAuthMethod = map['prevAuthMethod'] as String?,
        authMethod = map['authMethod'] as String?,
        mfaType = map['mfaType'] as String?,
        selectedAccountsCount = map['selectedAccountsCount'] as int?,
        errorType = map['errorType'] as String?,
        errorMessage = map['errorMessage'] as String?,
        institutionId =
            (map['institution'] as Map<String, dynamic>?)?['id'] as String?,
        institutionName =
            (map['institution'] as Map<String, dynamic>?)?['name'] as String?,
        timestamp = map['timestamp'] != null
            ? DateTime.fromMillisecondsSinceEpoch(map['timestamp'] as int)
            : DateTime.now();

  /// The type of event, typically following the format `mono.connect.xxxx`.
  final String eventType;

  /// An optional reference passed through the config or returned from the widget.
  final String? reference;

  /// The name of the page where the widget exited.
  final String? pageName;

  /// The auth method before it was last changed.
  final String? prevAuthMethod;

  /// The current auth method.
  final String? authMethod;

  /// The type of MFA the current user/bank requires.
  final String? mfaType;

  /// The number of accounts selected by the user.
  final int? selectedAccountsCount;

  /// The type of error thrown by the widget, if any.
  final String? errorType;

  /// A message describing the error thrown, if any.
  final String? errorMessage;

  /// ID of the institution.
  final String? institutionId;

  /// The name of the institution
  final String? institutionName;

  /// The timestamp of the event as a [DateTime] object.
  final DateTime timestamp;

  /// Converts the [ConnectEventData] instance to a [Map].
  ///
  /// The `timestamp` is represented as milliseconds since epoch.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': eventType,
      'reference': reference,
      'pageName': pageName,
      'prevAuthMethod': prevAuthMethod,
      'authMethod': authMethod,
      'mfaType': mfaType,
      'selectedAccountsCount': selectedAccountsCount,
      'errorType': errorType,
      'errorMessage': errorMessage,
      'institution': {
        'id': institutionId,
        'name': institutionName,
      },
      'timestamp': timestamp.millisecondsSinceEpoch,
    };
  }

  @override
  List<Object?> get props {
    return <Object?>[
      eventType,
      reference,
      pageName,
      prevAuthMethod,
      authMethod,
      mfaType,
      selectedAccountsCount,
      errorType,
      errorMessage,
      institutionId,
      institutionName,
      timestamp,
    ];
  }

  @override
  String toString() =>
      'ConnectEventData(eventType: $eventType, reference: $reference, pageName: $pageName, prevAuthMethod: $prevAuthMethod, authMethod: $authMethod, mfaType: $mfaType, selectedAccountsCount: $selectedAccountsCount, errorType: $errorType, errorMessage: $errorMessage, institutionId: $institutionId, institutionName: $institutionName, timestamp: $timestamp)';
}

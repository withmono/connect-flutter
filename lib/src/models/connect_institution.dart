import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:mono_connect/src/utils/extensions.dart';

enum ConnectAuthMethod {
  internetBanking('internet_banking'),
  mobileBanking('mobile_banking');

  const ConnectAuthMethod(this.value);

  final String value;

  static ConnectAuthMethod fromValue(String value) {
    final type =
        ConnectAuthMethod.values.firstWhereOrNull((e) => e.value == value);

    return type ?? ConnectAuthMethod.internetBanking;
  }
}

class ConnectInstitution extends Equatable {
  const ConnectInstitution({
    required this.id,
    required this.authMethod,
    this.accountNumber,
  });

  factory ConnectInstitution.fromMap(Map<String, dynamic> map) {
    return ConnectInstitution(
      id: map['id'] as String,
      authMethod: ConnectAuthMethod.fromValue(map['auth_method'] as String),
      accountNumber: map['account_number'] as String?,
    );
  }

  factory ConnectInstitution.fromJson(String source) =>
      ConnectInstitution.fromMap(json.decode(source) as Map<String, dynamic>);

  final String id;
  final String? accountNumber;
  final ConnectAuthMethod authMethod;

  ConnectInstitution copyWith({
    String? id,
    String? accountNumber,
    ConnectAuthMethod? authMethod,
  }) {
    return ConnectInstitution(
      id: id ?? this.id,
      authMethod: authMethod ?? this.authMethod,
      accountNumber: accountNumber ?? this.accountNumber,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'auth_method': authMethod.value,
      if (accountNumber != null) 'account_number': accountNumber,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'ConnectInstitution(id: $id, authMethod: $authMethod, accountNumber: $accountNumber)';

  @override
  List<Object?> get props => [id, authMethod, accountNumber];
}

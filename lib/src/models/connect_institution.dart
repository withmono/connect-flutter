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
  });

  factory ConnectInstitution.fromMap(Map<String, dynamic> map) {
    return ConnectInstitution(
      id: map['id'] as String,
      authMethod: ConnectAuthMethod.fromValue(map['auth_method'] as String),
    );
  }

  factory ConnectInstitution.fromJson(String source) =>
      ConnectInstitution.fromMap(json.decode(source) as Map<String, dynamic>);

  final String id;
  final ConnectAuthMethod authMethod;

  ConnectInstitution copyWith({
    String? id,
    ConnectAuthMethod? authMethod,
  }) {
    return ConnectInstitution(
      id: id ?? this.id,
      authMethod: authMethod ?? this.authMethod,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'auth_method': authMethod.value,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'ConnectInstitution(id: $id, authMethod: $authMethod)';

  @override
  List<Object> get props => [id, authMethod];
}

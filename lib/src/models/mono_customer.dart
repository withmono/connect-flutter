import 'dart:convert';

class MonoCustomer {
  const MonoCustomer({
    this.existingCustomer,
    this.newCustomer,
  });

  final MonoExistingCustomer? existingCustomer;
  final MonoNewCustomer? newCustomer;
}

class MonoExistingCustomer {
  const MonoExistingCustomer({
    required this.id,
  });

  MonoExistingCustomer.fromMap(Map<String, dynamic> map)
      : id = map['id'] as String? ?? '';

  factory MonoExistingCustomer.fromJson(String source) =>
      MonoExistingCustomer.fromMap(json.decode(source) as Map<String, dynamic>);

  final String id;

  MonoExistingCustomer copyWith({
    String? id,
  }) {
    return MonoExistingCustomer(
      id: id ?? this.id,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'id': id,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'MonoExistingCustomer(id: $id)';
}

class MonoNewCustomer {
  const MonoNewCustomer({
    required this.name,
    required this.email,
    this.identity,
  });

  MonoNewCustomer.fromMap(Map<String, dynamic> map)
      : name = map['name'] as String? ?? '',
        email = map['email'] as String? ?? '',
        identity = map['identity'] != null
            ? MonoCustomerIdentity.fromMap(
                map['identity'] as Map<String, dynamic>,
              )
            : null;

  factory MonoNewCustomer.fromJson(String source) =>
      MonoNewCustomer.fromMap(json.decode(source) as Map<String, dynamic>);

  final String name;
  final String email;
  final MonoCustomerIdentity? identity;

  MonoNewCustomer copyWith({
    String? name,
    String? email,
    MonoCustomerIdentity? identity,
  }) {
    return MonoNewCustomer(
      name: name ?? this.name,
      email: email ?? this.email,
      identity: identity ?? this.identity,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'name': name,
      'email': email,
      if (identity != null) 'identity': identity!.toMap(),
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() =>
      'MonoNewCustomer(name: $name, email: $email, identity: $identity)';
}

class MonoCustomerIdentity {
  const MonoCustomerIdentity({
    required this.type,
    required this.number,
  });

  MonoCustomerIdentity.fromMap(Map<String, dynamic> map)
      : type = map['type'] as String? ?? '',
        number = map['number'] as String? ?? '';

  factory MonoCustomerIdentity.fromJson(String source) =>
      MonoCustomerIdentity.fromMap(json.decode(source) as Map<String, dynamic>);

  final String type;
  final String number;

  MonoCustomerIdentity copyWith({
    String? type,
    String? number,
  }) {
    return MonoCustomerIdentity(
      type: type ?? this.type,
      number: number ?? this.number,
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'number': number,
    };
  }

  String toJson() => json.encode(toMap());

  @override
  String toString() => 'MonoCustomerIdentity(type: $type, number: $number)';
}

extension MonoCustomerToJson on MonoCustomer {
  Map<String, dynamic> toMap() {
    return existingCustomer?.toMap() ?? newCustomer?.toMap() ?? {};
  }

  String toJson() => json.encode(toMap());
}

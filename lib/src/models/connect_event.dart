import 'package:equatable/equatable.dart';
import 'package:mono_connect/src/models/connect_event_data.dart';
import 'package:mono_connect/src/models/connect_event_type.dart';
import 'package:mono_connect/src/utils/constants.dart';

/// Represents an event dispatched by the Mono Connect Widget.
class ConnectEvent extends Equatable {
  /// Creates a [ConnectEvent] with the given [type] and [data].
  const ConnectEvent({required this.type, required this.data});

  /// Creates a [ConnectEvent] instance from a [Map].
  ConnectEvent.fromMap(Map<String, dynamic> map)
      : type = ConnectEventType.fromValue(
          map['type'] as String? ?? Constants.UNKNOWN,
        ),
        data = ConnectEventData.fromMap(
          map['data'] as Map<String, dynamic>? ?? {},
        );

  /// The type of the event, represented by an [ConnectEventType].
  final ConnectEventType type;

  /// The data associated with the event, encapsulated in an [ConnectEventData] object.
  final ConnectEventData data;

  /// Converts the [ConnectEvent] into a [Map] representation.
  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'type': type.value,
      'data': data.toMap(),
    };
  }

  @override
  List<Object?> get props => <Object?>[type, data];

  @override
  String toString() => 'ConnectEvent(type: $type, data: $data)';
}

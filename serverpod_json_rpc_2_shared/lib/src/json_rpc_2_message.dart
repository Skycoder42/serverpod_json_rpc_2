import 'package:serverpod_serialization/serverpod_serialization.dart';

/// An internal helper model to wrap JSON RPC 2.0 messages
class JsonRpc2Message with SerializableEntity {
  /// The raw json data being wrapped
  final dynamic raw;

  /// Construct message from [raw] json data
  JsonRpc2Message(this.raw);

  /// @nodoc
  factory JsonRpc2Message.fromJson(
    dynamic json,
    // ignore: avoid_unused_constructor_parameters
    SerializationManager serializationManager,
  ) =>
      JsonRpc2Message(json);

  /// @nodoc
  @override
  dynamic toJson() => raw;
}

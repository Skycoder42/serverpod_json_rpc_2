import 'package:serverpod_serialization/serverpod_serialization.dart';

/// An internal helper model to wrap JSON RPC 2.0 messages
class JsonRpc2Message with SerializableEntity {
  final dynamic _raw;

  /// @nodoc
  JsonRpc2Message.raw(this._raw);

  /// @nodoc
  factory JsonRpc2Message.fromJson(
    dynamic json,
    // ignore: avoid_unused_constructor_parameters
    SerializationManager serializationManager,
  ) =>
      JsonRpc2Message.raw(json);

  @override
  dynamic toJson() => _raw;
}

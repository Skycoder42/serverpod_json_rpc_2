import 'package:serverpod_client/serverpod_client.dart';

/// Exception that is thrown when trying to create a stream channel for an
/// endpoint that has no open streaming connection.
class InvalidStreamingStatusException implements Exception {
  /// The [StreamingConnectionStatus] of the client.
  final StreamingConnectionStatus status;

  /// Default constructor.
  InvalidStreamingStatusException(this.status);

  @override
  String toString() =>
      'InvalidStreamingStatusException: client is not in the connected state '
      '(current state: ${status.name})';
}

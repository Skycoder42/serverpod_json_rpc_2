import 'package:json_rpc_2/json_rpc_2.dart' as rpc;
import 'package:serverpod_client/serverpod_client.dart';
import 'package:serverpod_json_rpc_2_shared/serverpod_json_rpc_2_shared.dart';
import 'package:stream_channel/stream_channel.dart';

import 'endpoint_stream_channel.dart';

/// An extension on [EndpointRef]s that use the [EndpointStreamChannel]
/// extension to create JSON RPC 2.0 instances.
///
/// See [EndpointStreamChannel] for more details on how these channels behave.
extension EndpointRpc on EndpointRef {
  /// Creates a [rpc.Client].
  ///
  /// Internally, this uses [createStreamChannel] to obtain a stream channel for
  /// the endpoint. This methods throws for the same reasons as
  /// [createStreamChannel].
  rpc.Client createClient() => rpc.Client.withoutJson(_createRpcChannel());

  /// Creates a [rpc.Server].
  ///
  /// Internally, this uses [createStreamChannel] to obtain a stream channel for
  /// the endpoint. This methods throws for the same reasons as
  /// [createStreamChannel].
  rpc.Server createServer({
    void Function(dynamic, dynamic)? onUnhandledError,
    bool strictProtocolChecks = true,
  }) =>
      rpc.Server.withoutJson(
        _createRpcChannel(),
        onUnhandledError: onUnhandledError,
        strictProtocolChecks: strictProtocolChecks,
      );

  /// Creates a [rpc.Peer].
  ///
  /// Internally, this uses [createStreamChannel] to obtain a stream channel for
  /// the endpoint. This methods throws for the same reasons as
  /// [createStreamChannel].
  rpc.Peer createPeer({
    void Function(dynamic, dynamic)? onUnhandledError,
    bool strictProtocolChecks = true,
  }) =>
      rpc.Peer.withoutJson(
        _createRpcChannel(),
        onUnhandledError: onUnhandledError,
        strictProtocolChecks: strictProtocolChecks,
      );

  StreamChannel _createRpcChannel() =>
      createStreamChannel().transform(RpcStreamChannelTransformer());
}
